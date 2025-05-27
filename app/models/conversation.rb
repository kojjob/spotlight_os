class Conversation < ApplicationRecord
  belongs_to :lead
  belongs_to :assistant

  # Associations
  has_one :user, through: :assistant
  has_many :transcripts, dependent: :destroy

  # Validations
  validates :source, inclusion: { in: %w[phone web chat sms email] }
  validates :status, inclusion: { in: %w[active paused completed abandoned] }
  validates :score, numericality: { in: 0..100, allow_nil: true }
  validates :duration, numericality: { greater_than: 0, allow_nil: true }

  # Enums
  enum :status, {
    active: "active",
    paused: "paused",
    completed: "completed",
    abandoned: "abandoned"
  }

  enum :source, {
    phone: "phone",
    web: "web",
    chat: "chat",
    sms: "sms",
    email: "email"
  }

  # Scopes
  scope :active, -> { where(status: "active") }
  scope :completed, -> { where(status: "completed") }
  scope :recent, -> { where("created_at >= ?", 24.hours.ago) }
  scope :by_source, ->(source) { where(source: source) }
  scope :high_score, -> { where("score >= ?", 70) }

  # Callbacks
  before_save :calculate_duration, if: :will_save_change_to_ended_at?
  after_update :update_lead_score, if: :saved_change_to_score?

  # Instance methods
  def duration_in_minutes
    return 0 unless duration
    (duration / 60.0).round(2)
  end

  def is_ongoing?
    active? && ended_at.nil?
  end

  def conversation_summary
    return "No transcripts available" if transcripts.empty?

    total_messages = transcripts.count
    user_messages = transcripts.where(speaker: "user").count
    assistant_messages = transcripts.where(speaker: "assistant").count

    "#{total_messages} messages (#{user_messages} from lead, #{assistant_messages} from assistant)"
  end

  def average_sentiment
    return 0.0 if transcripts.empty?

    sentiments = transcripts.where.not(sentiment: nil).pluck(:sentiment)
    return 0.0 if sentiments.empty?

    sentiment_scores = sentiments.map do |sentiment|
      case sentiment.downcase
      when "positive" then 1.0
      when "neutral" then 0.0
      when "negative" then -1.0
      else 0.0
      end
    end

    (sentiment_scores.sum / sentiment_scores.length).round(2)
  end

  def needs_attention?
    is_ongoing? && (
      average_sentiment < -0.3 ||
      duration_in_minutes > 30 ||
      transcripts.where(speaker: "user").where("created_at > ?", 5.minutes.ago).empty?
    )
  end

  private

  def calculate_duration
    if started_at && ended_at
      self.duration = (ended_at - started_at).to_i
    end
  end

  def update_lead_score
    return unless score.present?

    # Update lead score based on conversation performance
    current_lead_score = lead.score || 0
    new_score = ((current_lead_score + score) / 2.0).round
    lead.update(score: new_score)
  end
end
