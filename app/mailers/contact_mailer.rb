class ContactMailer < ApplicationMailer
  default from: 'Spotlight OS <hello@spotlightos.com>'

  def new_inquiry(contact_form)
    @contact_form = contact_form
    @priority = determine_priority(contact_form.inquiry_type)
    
    # Determine recipients based on inquiry type
    recipients = case contact_form.inquiry_type
                when 'demo', 'pricing'
                  ['sales@spotlightos.com']
                when 'support'
                  ['support@spotlightos.com']
                when 'partnership'
                  ['partnerships@spotlightos.com']
                else
                  ['hello@spotlightos.com']
                end
    
    mail(
      to: recipients,
      cc: 'hello@spotlightos.com',
      subject: "[#{@priority}] New #{contact_form.inquiry_type.humanize} Inquiry from #{contact_form.first_name} #{contact_form.last_name}",
      reply_to: contact_form.email
    )
  end

  def confirmation(contact_form)
    @contact_form = contact_form
    
    mail(
      to: contact_form.email,
      subject: "Thank you for contacting Spotlight OS - We'll be in touch soon!",
      template_name: 'confirmation'
    )
  end

  private

  def determine_priority(inquiry_type)
    case inquiry_type
    when 'demo', 'partnership'
      'HIGH PRIORITY'
    when 'pricing', 'support'
      'MEDIUM PRIORITY'
    else
      'NORMAL PRIORITY'
    end
  end
end
