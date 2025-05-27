# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create default users
puts "Creating default users..."

admin_user = User.find_or_create_by!(email: "admin@spotlightos.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.name = "Admin User"
  user.role = :admin
  user.company = "Spotlight OS"
  user.plan = :enterprise
end

sales_user = User.find_or_create_by!(email: "sales@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.name = "Sarah Johnson"
  user.role = :sales_manager
  user.company = "TechCorp Solutions"
  user.plan = :professional
end

demo_user = User.find_or_create_by!(email: "demo@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.name = "Demo User"
  user.role = :user
  user.company = "Demo Company"
  user.plan = :trial
end

puts "Created #{User.count} users"

# Create AI assistants
puts "Creating AI assistants..."

sales_assistant = Assistant.find_or_create_by!(name: "SalesBot Pro", user: sales_user) do |assistant|
  assistant.role = "Lead Qualification and Sales Assistant"
  assistant.script = "You are a professional sales assistant. Your goal is to qualify leads and book appointments. Be friendly, helpful, and focus on understanding the prospect's needs. Ask about their business challenges, budget, and timeline."
  assistant.tone = :professional
  assistant.voice_id = "rachel"
  assistant.language = "en"
  assistant.active = true
end

support_assistant = Assistant.find_or_create_by!(name: "Support Helper", user: admin_user) do |assistant|
  assistant.role = "Customer Support and Technical Assistant"
  assistant.script = "You are a helpful customer support assistant. Provide clear, accurate information and guide users to solutions. Focus on resolving issues quickly and ensuring customer satisfaction."
  assistant.tone = :friendly
  assistant.voice_id = "emily"
  assistant.language = "en"
  assistant.active = true
end

demo_assistant = Assistant.find_or_create_by!(name: "Demo Assistant", user: demo_user) do |assistant|
  assistant.role = "Platform Demo and Feature Showcase Assistant"
  assistant.script = "You are a demo assistant showcasing the Spotlight OS platform. Be engaging and highlight key features. Demonstrate the platform's capabilities and help prospects understand the value proposition."
  assistant.tone = :casual
  assistant.voice_id = "adam"
  assistant.language = "en"
  assistant.active = true
end

puts "Created #{Assistant.count} assistants"

# Create sample leads
puts "Creating sample leads..."

lead_data = [
  {
    name: "John Smith", email: "john.smith@techstart.com",
    phone: "+1-555-1001", company: "TechStart Inc", status: :qualified,
    score: 85, source: :website
  },
  {
    name: "Maria Garcia", email: "maria@innovatecorp.com",
    phone: "+1-555-1002", company: "InnovateCorp", status: :contacted,
    score: 72, source: :referral
  },
  {
    name: "David Chen", email: "d.chen@futuretech.io",
    phone: "+1-555-1003", company: "FutureTech", status: :fresh,
    score: 68, source: :social_media
  },
  {
    name: "Lisa Brown", email: "lisa.brown@megacorp.com",
    phone: "+1-555-1004", company: "MegaCorp Ltd", status: :converted,
    score: 95, source: :paid_ads
  },
  {
    name: "Alex Wilson", email: "alex@startupworld.com",
    phone: "+1-555-1005", company: "StartupWorld", status: :nurturing,
    score: 45, source: :cold_email
  }
]

lead_data.each do |lead_info|
  Lead.find_or_create_by!(email: lead_info[:email], assistant: sales_assistant) do |lead|
    lead.name = lead_info[:name]
    lead.phone = lead_info[:phone]
    lead.company = lead_info[:company]
    lead.status = lead_info[:status]
    lead.score = lead_info[:score]
    lead.source = lead_info[:source]
    lead.qualified = [ :qualified, :converted ].include?(lead_info[:status])
  end
end

puts "Created #{Lead.count} leads"

# Create sample conversations
puts "Creating sample conversations..."

leads = Lead.all
assistants = Assistant.all

leads.each_with_index do |lead, index|
  assistant = assistants[index % assistants.count]

  conversation = Conversation.find_or_create_by!(
    lead: lead,
    assistant: assistant
  ) do |conv|
    conv.status = [ :active, :completed, :paused ].sample
    conv.duration = rand(120..1800) # 2-30 minutes
    conv.score = rand(30..95)
    conv.source = [ :phone, :web, :chat ].sample
    conv.started_at = rand(7.days).seconds.ago
    conv.ended_at = conv.started_at + conv.duration.seconds if conv.status == "completed"
  end

  # Create sample transcripts for each conversation
  if conversation.persisted?
    sample_messages = [
      { role: "assistant", content: "Hi! Thanks for your interest in our platform. How can I help you today?" },
      { role: "user", content: "I'm looking for a solution to automate our sales process." },
      { role: "assistant", content: "That's great! Can you tell me more about your current sales process and team size?" },
      { role: "user", content: "We have about 20 sales reps and we're handling leads manually right now." },
      { role: "assistant", content: "I understand. Our platform can definitely help streamline that process. What's your biggest challenge right now?" }
    ]

    sample_messages.each_with_index do |message, msg_index|
      Transcript.find_or_create_by!(
        conversation: conversation,
        content: message[:content],
        speaker: message[:role]
      ) do |transcript|
        transcript.sentiment = [ "positive", "neutral", "negative" ].sample
        transcript.confidence = rand(0.85..0.98).round(3)
        transcript.timestamp = conversation.started_at.to_f + (msg_index * 30)
      end
    end
  end
end

puts "Created #{Conversation.count} conversations with #{Transcript.count} transcript entries"

# Create sample appointments
puts "Creating sample appointments..."

qualified_leads = Lead.where(status: [ :qualified, :converted ])
qualified_leads.each do |lead|
  next if rand > 0.6 # Only create appointments for 60% of qualified leads

  Appointment.find_or_create_by!(lead: lead, assistant: lead.assistant) do |appointment|
    appointment.scheduled_at = rand(1..30).days.from_now
    appointment.duration = [ 30, 45, 60 ].sample
    appointment.status = [ :scheduled, :completed, :cancelled ].sample
    appointment.external_link = "https://meet.spotlightos.com/#{SecureRandom.hex(8)}"
    appointment.external_id = "cal_#{SecureRandom.hex(12)}"
    appointment.metadata = {
      title: "Sales Call - #{lead.company}",
      description: "Discuss #{lead.company}'s requirements and demonstrate platform capabilities"
    }
  end
end

puts "Created #{Appointment.count} appointments"

puts "\n✅ Seed data created successfully!"
puts "👤 Users: #{User.count}"
puts "🤖 Assistants: #{Assistant.count}"
puts "📊 Leads: #{Lead.count}"
puts "💬 Conversations: #{Conversation.count}"
puts "📝 Transcripts: #{Transcript.count}"
puts "📅 Appointments: #{Appointment.count}"
puts "\n🔑 Login credentials:"
puts "Admin: admin@spotlightos.com / password123"
puts "Sales Manager: sales@example.com / password123"
puts "Demo User: demo@example.com / password123"
