class Lead < ApplicationRecord
  belongs_to :assistant

  # Associations
  has_one :user, through: :assistant
  has_many :conversations, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :transcripts, through: :conversations

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, format: { with: /\A[\+]?[1-9][\d\s\-\(\)]{7,15}\z/ }
  validates :status, inclusion: { in: %w[fresh contacted qualified unqualified converted lost nurturing] }
  validates :source, inclusion: { in: %w[website phone social_media email referral paid_ads cold_email] }
  validates :score, numericality: { in: 0..100, allow_nil: true }

  # Enums
  enum :status, {
    fresh: "fresh",
    contacted: "contacted",
    qualified: "qualified",
    unqualified: "unqualified",
    converted: "converted",
    lost: "lost",
    nurturing: "nurturing"
  }

  enum :source, {
    website: "website",
    phone: "phone",
    social_media: "social_media",
    email: "email",
    referral: "referral",
    paid_ads: "paid_ads",
    cold_email: "cold_email"
  }

  # Scopes
  scope :qualified, -> { where(qualified: true) }
  scope :unqualified, -> { where(qualified: false) }
  scope :by_source, ->(source) { where(source: source) }
  scope :by_status, ->(status) { where(status: status) }
  scope :high_score, -> { where("score >= ?", 70) }
  scope :recent, -> { where("created_at >= ?", 30.days.ago) }

  # Callbacks
  before_save :update_qualified_status
  after_update :trigger_follow_up, if: :saved_change_to_status?

  # Instance methods
  def full_contact_info
    "#{name} (#{email}, #{phone})"
  end

  def days_since_created
    (Date.current - created_at.to_date).to_i
  end

  def latest_conversation
    conversations.order(created_at: :desc).first
  end

  def total_conversation_time
    conversations.sum(:duration) || 0
  end

  def engagement_level
    case score
    when 0..30
      "Low"
    when 31..60
      "Medium"
    when 61..80
      "High"
    when 81..100
      "Very High"
    else
      "Unknown"
    end
  end

  def needs_follow_up?
    return false if converted? || lost?
    latest_conversation.nil? || latest_conversation.created_at < 3.days.ago
  end

  private

  def update_qualified_status
    self.qualified = score.present? && score >= 50
  end

  def trigger_follow_up
    # Trigger background job for follow-up actions
    # FollowUpJob.perform_later(self) if qualified?
  end
end
