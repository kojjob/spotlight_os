class ConversationAnalyzerJob < ApplicationJob
  queue_as :default

  def perform(conversation_id)
    conversation = Conversation.find_by(id: conversation_id)
    return unless conversation

    Rails.logger.info "Analyzing conversation #{conversation_id}"

    # Analyze overall conversation sentiment
    analyze_conversation_sentiment(conversation)

    # Update lead score based on conversation
    update_lead_score(conversation)

    # Generate conversation summary
    generate_conversation_summary(conversation)

    # Check if follow-up is needed
    schedule_follow_up_if_needed(conversation)

    Rails.logger.info "Completed analysis for conversation #{conversation_id}"
  end

  private

  def analyze_conversation_sentiment(conversation)
    return if conversation.transcripts.empty?

    sentiments = conversation.transcripts.where.not(sentiment: nil).pluck(:sentiment)
    return if sentiments.empty?

    sentiment_scores = sentiments.map do |sentiment|
      case sentiment.downcase
      when "positive" then 1.0
      when "neutral" then 0.0
      when "negative" then -1.0
      else 0.0
      end
    end

    avg_sentiment = sentiment_scores.sum / sentiment_scores.length

    # Update conversation score based on sentiment
    current_score = conversation.score || 50
    sentiment_adjustment = (avg_sentiment * 20).round
    new_score = [ [ current_score + sentiment_adjustment, 0 ].max, 100 ].min

    conversation.update!(score: new_score)
  end

  def update_lead_score(conversation)
    lead = conversation.lead
    return unless lead

    # Calculate weighted average of all conversation scores for this lead
    conversation_scores = lead.conversations.where.not(score: nil).pluck(:score)
    return if conversation_scores.empty?

    avg_conversation_score = conversation_scores.sum.to_f / conversation_scores.length

    # Update lead score (weighted 70% conversation performance, 30% existing score)
    existing_score = lead.score || 50
    new_score = (avg_conversation_score * 0.7 + existing_score * 0.3).round

    lead.update!(score: new_score)

    # Update qualified status
    lead.update!(qualified: new_score >= 50)
  end

  def generate_conversation_summary(conversation)
    transcripts = conversation.transcripts.order(:created_at)
    return if transcripts.empty?

    total_messages = transcripts.count
    user_messages = transcripts.where(speaker: "user").count
    assistant_messages = transcripts.where(speaker: "assistant").count

    # Simple keyword extraction for topics discussed
    all_content = transcripts.pluck(:content).join(" ")
    keywords = extract_keywords(all_content)

    summary = {
      total_messages: total_messages,
      user_messages: user_messages,
      assistant_messages: assistant_messages,
      duration_minutes: conversation.duration_in_minutes,
      keywords: keywords,
      sentiment_summary: conversation.average_sentiment
    }

    Rails.logger.info "Conversation #{conversation.id} summary: #{summary}"
  end

  def schedule_follow_up_if_needed(conversation)
    lead = conversation.lead
    return unless lead

    # Schedule follow-up for qualified leads who haven't been contacted recently
    if lead.qualified? && !lead.converted? && conversation.completed?
      last_contact = lead.conversations.where(status: "completed").maximum(:ended_at)

      if last_contact.nil? || last_contact < 3.days.ago
        # In a real app, you might schedule an email or notification
        Rails.logger.info "Lead #{lead.id} needs follow-up"
        # FollowUpJob.perform_in(1.day, lead.id)
      end
    end
  end

  def extract_keywords(text)
    # Simple keyword extraction (in production, use NLP libraries)
    common_words = %w[the and or but for with to from at by of in on is are was were be been have has had will would could should]

    words = text.downcase.scan(/\b\w+\b/)
    word_freq = words.reject { |word| common_words.include?(word) || word.length < 3 }
                    .tally
                    .sort_by { |_, count| -count }
                    .first(5)
                    .map(&:first)

    word_freq
  end
end
