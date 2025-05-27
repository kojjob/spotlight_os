class ContactForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :first_name, :string
  attribute :last_name, :string
  attribute :email, :string
  attribute :company, :string
  attribute :phone, :string
  attribute :inquiry_type, :string
  attribute :message, :string

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :message, presence: true, length: { minimum: 10 }
  validates :inquiry_type, presence: true

  def name
    "#{first_name} #{last_name}".strip
  end

  def subject
    case inquiry_type
    when "demo"
      "Demo Request"
    when "general"
      "General Inquiry"
    when "support"
      "Technical Support"
    when "partnership"
      "Partnership Inquiry"
    when "pricing"
      "Pricing Information"
    else
      "Contact Form Submission"
    end
  end
end
