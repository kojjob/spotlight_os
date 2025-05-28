class Transcript < ApplicationRecord

  # Associations  
  belongs_to :conversation
  has_rich_text :content

  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 5000 }
  validates :speaker, inclusion: { in: %w[user assistant] }
  validates :sentiment, inclusion: { in: %w[positive neutral negative], allow_nil: true }
  validates :confidence, numericality: { in: 0..1, allow_nil: true }
  validates :timestamp, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  # Enums
  enum :speaker, {
    user: "user",
    assistant: "assistant"
  }

  enum :sentiment, {
    positive: "positive",
    neutral: "neutral",
    negative: "negative"
  }

  # Instance methods
  def as_json(options = {})
    super(options).merge(
      speaker: speaker,
      sentiment: sentiment,
      confidence: confidence,
      timestamp: timestamp
    )
  end
end
