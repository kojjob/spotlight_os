class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :assistants, dependent: :destroy
  has_many :leads, through: :assistants
  has_many :conversations, through: :assistants
  has_many :appointments, through: :assistants
  has_many :transcripts, through: :assistants

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :company, presence: true, length: { minimum: 2, maximum: 100 }
  validates :role, inclusion: { in: %w[owner admin sales_manager user] }
  validates :plan, inclusion: { in: %w[trial starter professional enterprise] }

  # Callbacks
  before_validation :set_default_plan, on: :create

  # Enums
  enum :role, { owner: "owner", admin: "admin", sales_manager: "sales_manager", user: "user" }
  enum :plan, { trial: "trial", starter: "starter", professional: "professional", enterprise: "enterprise" }

  # Scopes
  scope :active, -> { where.not(plan: "trial") }
  scope :by_plan, ->(plan) { where(plan: plan) }

  # Instance methods
  def full_name
    name
  end

  def total_leads
    leads.count
  end

  def qualified_leads
    leads.qualified.count
  end

  def conversion_rate
    return 0 if total_leads.zero?
    (qualified_leads.to_f / total_leads * 100).round(2)
  end

  def onboarding_completed?
    onboarding_completed == true
  end

  private

  def set_default_plan
    self.plan ||= 'trial'
    self.onboarding_step ||= 0  # 0 = welcome step
    self.onboarding_completed ||= false
  end
end
