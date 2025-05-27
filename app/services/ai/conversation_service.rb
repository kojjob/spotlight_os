class Ai::ConversationService
  def initialize(assistant, lead)
    @assistant = assistant
    @lead = lead
    @openai_client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def start_conversation
    conversation = create_conversation
    initial_response = generate_initial_response

    if initial_response
      create_transcript(initial_response, "assistant")
      conversation
    else
      nil
    end
  end

  def process_response(conversation, user_input)
    # Create transcript for user input
    create_transcript(user_input, "user", conversation)

    # Get conversation context
    context = build_conversation_context(conversation)

    # Generate AI response
    ai_response = generate_ai_response(context, user_input)

    if ai_response
      # Create transcript for AI response
      create_transcript(ai_response, "assistant", conversation)

      # Update conversation score based on interaction
      update_conversation_score(conversation, user_input, ai_response)

      ai_response
    else
      "I apologize, but I'm having trouble processing your request. Let me connect you with a human representative."
    end
  end

  def end_conversation(conversation)
    conversation.update!(
      status: "completed",
      ended_at: Time.current
    )

    # Trigger post-conversation analysis
    ConversationAnalyzerJob.perform_later(conversation.id)
  end

  private

  def create_conversation
    Conversation.create!(
      assistant: @assistant,
      lead: @lead,
      source: "web", # Default to web, can be overridden
      status: "active",
      started_at: Time.current
    )
  end

  def generate_initial_response
    system_prompt = build_system_prompt

    response = @openai_client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          {
            role: "system",
            content: system_prompt
          },
          {
            role: "user",
            content: "Please start the conversation by greeting the lead and introducing yourself."
          }
        ],
        temperature: 0.7,
        max_tokens: 150
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue => e
    Rails.logger.error "OpenAI API Error: #{e.message}"
    nil
  end

  def generate_ai_response(context, user_input)
    messages = [
      {
        role: "system",
        content: build_system_prompt
      },
      *context,
      {
        role: "user",
        content: user_input
      }
    ]

    response = @openai_client.chat(
      parameters: {
        model: "gpt-4",
        messages: messages,
        temperature: 0.7,
        max_tokens: 200
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue => e
    Rails.logger.error "OpenAI API Error: #{e.message}"
    nil
  end

  def build_system_prompt
    <<~PROMPT
      You are #{@assistant.name}, a #{@assistant.tone} AI sales assistant for #{@assistant.user.company}.

      Your role: #{@assistant.role}

      Your script guidelines: #{@assistant.script}

      Lead Information:
      - Name: #{@lead.name}
      - Company: #{@lead.company}
      - Source: #{@lead.source}

      Instructions:
      1. Maintain a #{@assistant.tone} tone throughout the conversation
      2. Focus on qualifying the lead based on their needs
      3. Ask relevant questions to understand their requirements
      4. Provide helpful information about our services
      5. Try to schedule a follow-up appointment if the lead is qualified
      6. Keep responses concise and conversational
      7. If you don't know something, be honest and offer to connect them with a human

      Remember: Your goal is to qualify leads and provide excellent customer service.
    PROMPT
  end

  def build_conversation_context(conversation)
    conversation.transcripts.order(:created_at).last(10).map do |transcript|
      {
        role: transcript.speaker == "assistant" ? "assistant" : "user",
        content: transcript.content
      }
    end
  end

  def create_transcript(content, speaker, conversation = nil)
    conversation ||= @conversation

    transcript = Transcript.create!(
      conversation: conversation,
      content: content,
      speaker: speaker,
      timestamp: Time.current.to_f
    )

    # Analyze sentiment for user messages
    if speaker == "user"
      SentimentAnalyzerJob.perform_later(transcript.id)
    end

    transcript
  end

  def update_conversation_score(conversation, user_input, ai_response)
    # Simple scoring based on conversation flow
    # This can be enhanced with more sophisticated analysis

    positive_indicators = [ "yes", "interested", "tell me more", "sounds good", "when can", "how much" ]
    negative_indicators = [ "no thanks", "not interested", "too expensive", "maybe later", "goodbye" ]

    user_input_lower = user_input.downcase

    score_change = 0

    if positive_indicators.any? { |indicator| user_input_lower.include?(indicator) }
      score_change += 10
    elsif negative_indicators.any? { |indicator| user_input_lower.include?(indicator) }
      score_change -= 15
    end

    # Length of response can indicate engagement
    if user_input.length > 50
      score_change += 5
    end

    current_score = conversation.score || 50
    new_score = [ [ current_score + score_change, 0 ].max, 100 ].min

    conversation.update!(score: new_score)

    # Update lead score as well
    lead_score_change = score_change / 2
    current_lead_score = @lead.score || 50
    new_lead_score = [ [ current_lead_score + lead_score_change, 0 ].max, 100 ].min
    @lead.update!(score: new_lead_score)
  end
end
