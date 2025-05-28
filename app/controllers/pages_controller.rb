class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing, :about, :contact, :create_contact, :demo]
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
  
  def demo
    @demo_videos = [
      {
        title: "Qualifying Leads with Voice AI",
        duration: "2:35",
        thumbnail: "demo_qualify_leads.jpg",
        description: "See how Spotlight OS qualifies leads through natural conversation",
        video_id: "spotlight-demo-1"
      },
      {
        title: "Booking Appointments Automatically",
        duration: "3:10",
        thumbnail: "demo_booking.jpg",
        description: "Watch our AI book meetings directly into your sales team's calendar",
        video_id: "spotlight-demo-2"
      },
      {
        title: "Analytics & Reporting Dashboard",
        duration: "2:45",
        thumbnail: "demo_analytics.jpg",
        description: "Explore the real-time analytics dashboard showing conversion metrics",
        video_id: "spotlight-demo-3"
      }
    ]
  end

  def contact
    @contact_form = ContactForm.new
  end

  def create_contact
    @contact_form = ContactForm.new(contact_params)
    
    if @contact_form.valid?
      # Send notification email to team
      ContactMailer.new_inquiry(@contact_form).deliver_later
      
      # Send confirmation email to customer
      ContactMailer.confirmation(@contact_form).deliver_later
      
      flash[:success] = "Thank you for your message! We've sent a confirmation to your email and will get back to you within 1 business hour."
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
