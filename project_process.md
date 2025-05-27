### ✅ Terminal commands to generate Spotlight OS core models & controllers

# Devise user model
rails g devise:install
rails g devise User name:string company:string role:string

# Assistant builder
rails g scaffold Assistant name:string tone:string role:string script:text user:references

# Lead capture
rails g scaffold Lead name:string email:string phone:string source:string qualified:boolean assistant:references

# Conversations & transcripts
rails g scaffold Conversation lead:references assistant:references source:string score:integer
rails g scaffold Transcript conversation:references content:text speaker:string sentiment:string

# Appointments (for booking calendar links)
rails g scaffold Appointment lead:references assistant:references scheduled_at:datetime status:string external_link:string

# Pages & Dashboards
rails g controller Dashboard index
rails g controller Assistants index show new edit
rails g controller Leads index show new edit
rails g controller Conversations index show

# Install TailwindCSS, Hotwire, Stimulus
rails tailwindcss:install
rails turbo:install
rails stimulus:install

# For background jobs (in Gemfile)
gem 'solid_queue'

# After bundle install, create config/initializers/sidekiq.rb

### ✅ Basic routes

# config/routes.rb
Rails.application.routes.draw do
  root 'dashboard#index'

  devise_for :users

  resources :assistants do
    resources :leads, only: [:new, :create, :index]
    resources :appointments, only: [:index]
  end

  resources :leads do
    resources :conversations, only: [:new, :create, :show]
  end

  resources :conversations do
    resources :transcripts, only: [:index]
  end

  get '/dashboard', to: 'dashboard#index'
end

### ✅ UI/UX Prompt for Design Tools or Tailwind/React CodeGen

"Design a professional, modern, responsive SaaS UI/UX for a voice AI sales platform. Include:
- Clean, minimal dashboard layout with sidebar navigation (Assistants, Leads, Conversations, Appointments, Billing)
- Components: AI Assistant Configurator, Conversation Transcript Viewer, Lead Qualification Flow, Real-time Chat Panel
- User-friendly onboarding wizard to create AI assistant
- Use soft shadows, rounded corners, large CTA buttons
- Responsive for desktop/tablet/mobile
- Colors: Deep Indigo + Sky Blue accents + Warm neutral grays
- Typography: Inter or Plus Jakarta Sans
- Visual hierarchy with charts, lead pipeline, and cards"

### ✅ Next Steps
# 1. Scaffold these resources and run migrations
# 2. Implement Hotwire interactions for conversation/live updates
# 3. Integrate OpenAI/Whisper/ElevenLabs APIs via services
# 4. Add Stripe + Calendly integration for appointments
