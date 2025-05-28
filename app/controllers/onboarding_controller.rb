class OnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_completed
  
  STEPS = %w[welcome company_info assistant_setup goals_setup completion].freeze

  def index
    redirect_to onboarding_step_path(current_step_name)
  end

  def show
    @step = params[:step]
    @step_number = STEPS.index(@step) + 1
    @total_steps = STEPS.length - 1 # Exclude completion step from count
    @progress_percentage = ((@step_number - 1).to_f / (@total_steps - 1) * 100).round

    case @step
    when 'welcome'
      current_user.update!(onboarding_step: 0) if current_user.onboarding_step.nil?
      render 'welcome'
    when 'company_info'
      render 'company_info'
    when 'assistant_setup'
      @assistant = current_user.assistants.build
      render 'assistant_setup'
    when 'goals_setup'
      render 'goals_setup'
    when 'completion'
      current_user.update!(
        onboarding_completed: true,
        onboarding_completed_at: Time.current,
        onboarding_step: 4
      )
      render 'completion'
    else
      redirect_to onboarding_path
    end
  end

  def update
    @step = params[:step]
    
    case @step
    when 'company_info'
      if current_user.update(company_info_params)
        advance_step(2) # assistant_setup
      else
        @step_number = 2
        @total_steps = STEPS.length - 1
        @progress_percentage = 25
        render 'company_info'
      end
    when 'assistant_setup'
      @assistant = current_user.assistants.build(assistant_params)
      @assistant.active = true  # Set as active by default during onboarding
      if @assistant.save
        advance_step(3) # goals_setup
      else
        @step_number = 3
        @total_steps = STEPS.length - 1
        @progress_percentage = 50
        render 'assistant_setup'
      end
    when 'goals_setup'
      # Process goals and preferences
      advance_step(4) # completion
    end
  end

  private

  def current_step_name
    step_index = current_user.onboarding_step || 0
    STEPS[step_index] || 'welcome'
  end

  def advance_step(step_index)
    step_name = STEPS[step_index]
    current_user.update!(onboarding_step: step_index)
    redirect_to onboarding_step_path(step_name)
  end

  def redirect_if_completed
    if current_user.onboarding_completed?
      redirect_to root_path, notice: 'You have already completed onboarding.'
    end
  end

  def company_info_params
    params.require(:user).permit(:company, :role)
  end

  def assistant_params
    params.require(:assistant).permit(:name, :tone, :role, :language, :voice_id).tap do |permitted_params|
      # Convert short role keys to full descriptions
      if permitted_params[:role].present?
        permitted_params[:role] = convert_role_to_description(permitted_params[:role])
        permitted_params[:script] = generate_default_script(permitted_params[:role])
      end
    end
  end

  def convert_role_to_description(role_key)
    case role_key
    when 'sales_rep'
      'Sales Representative and Lead Conversion Specialist'
    when 'lead_qualifier'
      'Lead Qualification and Prospecting Assistant'
    when 'support'
      'Customer Support and Service Representative'
    when 'appointment_setter'
      'Appointment Scheduling and Calendar Management Assistant'
    else
      role_key.length >= 10 ? role_key : 'General Sales and Customer Service Assistant'
    end
  end

  def generate_default_script(role_description)
    case role_description
    when /Sales Representative/
      "Hello! I'm an AI sales representative for #{current_user.company}. I'm here to help answer your questions about our products and services and find the best solution for your needs. How can I assist you today?"
    when /Lead Qualification/
      "Hi there! I'm an AI assistant helping #{current_user.company} understand how we can best serve potential customers like you. I'd love to learn more about your business needs and see if we're a good fit. What challenges are you currently facing?"
    when /Customer Support/
      "Hello! I'm an AI customer support representative for #{current_user.company}. I'm here to help resolve any questions or issues you might have with our products or services. What can I help you with today?"
    when /Appointment Scheduling/
      "Hi! I'm an AI scheduling assistant for #{current_user.company}. I can help you book a consultation or meeting with our team to discuss how we can help your business. Would you like to schedule some time to discuss your needs?"
    else
      "Hello! I'm an AI assistant for #{current_user.company}. I'm here to help answer your questions and provide information about our products and services. How can I assist you today?"
    end
  end
end
