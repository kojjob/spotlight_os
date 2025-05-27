class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing, :about, :contact, :create_contact]
  layout 'marketing'
  
  def landing
    @stats = {
      total_conversations: 10000,
      leads_qualified: 8500,
      conversion_rate: 85,
      avg_response_time: 2.3
    }
  end

  def about
  end

  def contact
    @contact_form = ContactForm.new
  end

  def create_contact
    @contact_form = ContactForm.new(contact_params)
    
    if @contact_form.valid?
      # Send contact email (implement mailer)
      # ContactMailer.new_inquiry(@contact_form).deliver_later
      
      flash[:success] = "Thank you for your message. We'll get back to you soon!"
      redirect_to contact_path
    else
      render :contact, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact_form).permit(:first_name, :last_name, :email, :company, :phone, :message, :inquiry_type)
  end
end
