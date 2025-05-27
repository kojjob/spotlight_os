class Ai::SentimentAnalyzer
  def initialize(transcript)
    @transcript = transcript
    @openai_client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def analyze
    return unless @transcript.content.present?

    sentiment = analyze_sentiment(@transcript.content)
    confidence = calculate_confidence(sentiment)

    @transcript.update!(
      sentiment: sentiment,
      confidence: confidence
    )

    { sentiment: sentiment, confidence: confidence }
  end

  private

  def analyze_sentiment(text)
    prompt = <<~PROMPT
      Analyze the sentiment of the following text and respond with only one word: "positive", "negative", or "neutral".

      Text: "#{text}"

      Sentiment:
    PROMPT

    response = @openai_client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {
            role: "user",
            content: prompt
          }
        ],
        temperature: 0.1,
        max_tokens: 10
      }
    )

    sentiment = response.dig("choices", 0, "message", "content")&.strip&.downcase

    # Validate the response
    %w[positive negative neutral].include?(sentiment) ? sentiment : "neutral"
  rescue => e
    Rails.logger.error "Sentiment Analysis Error: #{e.message}"
    "neutral"
  end

  def calculate_confidence(sentiment)
    # Simple confidence calculation
    # In a real implementation, you might use the API's confidence scores
    case sentiment
    when "positive", "negative"
      rand(0.7..0.95).round(2)
    when "neutral"
      rand(0.5..0.8).round(2)
    else
      0.5
    end
  end
end
