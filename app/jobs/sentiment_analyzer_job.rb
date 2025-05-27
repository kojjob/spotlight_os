class SentimentAnalyzerJob < ApplicationJob
  queue_as :default

  def perform(transcript_id)
    transcript = Transcript.find_by(id: transcript_id)
    return unless transcript

    Rails.logger.info "Analyzing sentiment for transcript #{transcript_id}"

    analyzer = Ai::SentimentAnalyzer.new(transcript)
    result = analyzer.analyze

    if result
      Rails.logger.info "Sentiment analysis complete: #{result[:sentiment]} (#{result[:confidence]})"

      # Trigger conversation analysis if this was the last message
      conversation = transcript.conversation
      if conversation.transcripts.order(:created_at).last == transcript
        ConversationAnalyzerJob.perform_later(conversation.id)
      end
    else
      Rails.logger.error "Failed to analyze sentiment for transcript #{transcript_id}"
    end
  end
end
