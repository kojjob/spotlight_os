class DealRoomSummaryService
  def initialize(deal_room)
    @deal_room = deal_room
  end

  def generate_summary
    conversations = @deal_room.conversations.includes(:transcript)
    recent_conversation = conversations.order(created_at: :desc).first
    
    analysis = analyze_conversations(conversations)
    
    {
      key_points: extract_key_points(analysis),
      next_steps: determine_next_steps(analysis),
      risk_assessment: assess_risk(analysis)
    }
  end

  private

  def analyze_conversations(conversations)
    ai_service = Spotlight::AIService.new
    
    conversation_texts = conversations.map do |c|
      {
        id: c.id,
        content: c.transcript&.content || '',
        metadata: {
          created_at: c.created_at,
          sentiment_score: c.sentiment_score
        }
      }
    end
    
    ai_response = ai_service.analyze_conversations(
      conversations: conversation_texts,
      deal_stage: @deal_room.stage
    )
    
    {
      sentiment: ai_response[:average_sentiment],
      topics: ai_response[:topics],
      action_items: ai_response[:action_items]
    }
  rescue Spotlight::AIService::Error => e
    Rails.logger.error("AI Service Error: #{e.message}")
    {
      sentiment: conversations.average(:sentiment_score) || 0.5,
      topics: [],
      action_items: []
    }
  end

  def extract_key_points(analysis)
    [
      "Lead is in #{@deal_room.stage} stage",
      "Average sentiment score: #{analysis[:sentiment].round(2)}",
      "Key topics discussed: #{analysis[:topics].join(', ')}"
    ]
  end

  def determine_next_steps(analysis)
    steps = []
    steps << "Follow up on: #{analysis[:action_items].join(', ')}" if analysis[:action_items].any?
    steps << "Address concerns about: #{analysis[:topics].select { |t| analysis[:sentiment] < 0.3 }.join(', ')}" if analysis[:sentiment] < 0.3
    steps << "Send proposal documents" if @deal_room.stage == "proposal"
    steps.presence || ["Schedule next check-in"]
  end

  def assess_risk(analysis)
    case analysis[:sentiment]
    when 0.0..0.3 then "High risk - negative sentiment detected"
    when 0.3..0.6 then "Medium risk - neutral sentiment"
    else "Low risk - positive sentiment"
    end
  end
end