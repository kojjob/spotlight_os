class Assistant < ApplicationRecord
  belongs_to :user

  # Associations
  has_many :leads, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :transcripts, through: :conversations

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :tone, inclusion: { in: %w[professional friendly casual authoritative empathetic] }
  validates :role, presence: true, length: { minimum: 10, maximum: 500 }
  validates :script, presence: true, length: { minimum: 50, maximum: 2000 }
  validates :language, inclusion: { in: %w[en es fr de it pt] }

  # Enums
  enum :tone, {
    professional: "professional",
    friendly: "friendly",
    casual: "casual",
    authoritative: "authoritative",
    empathetic: "empathetic"
  }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_language, ->(lang) { where(language: lang) }

  # Callbacks
  before_create :set_defaults

  # Instance methods
  def toggle_active!
    update!(active: !active)
  end

  def average_lead_score
    return 0 if leads.empty?
    leads.where.not(score: nil).average(:score).to_f.round(2)
  end

  def total_conversations
    conversations.count
  end

  def active_conversations
    conversations.where(status: "active").count
  end

  def conversation_completion_rate
    return 0 if total_conversations.zero?
    completed = conversations.where(status: "completed").count
    (completed.to_f / total_conversations * 100).round(2)
  end

  private

  def set_defaults
    self.active = true if active.nil?
    self.language = "en" if language.blank?
    self.tone = "professional" if tone.blank?
  end
end
