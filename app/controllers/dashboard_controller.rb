class DashboardController < ApplicationController
    def index
     @deal_rooms = current_user.deal_rooms.includes(:lead, :conversations).order(created_at: :desc)
    @stats = {
      total_assistants: current_user_assistants.count,
      active_assistants: current_user_assistants.active.count,
      total_leads: current_user_leads.count,
      qualified_leads: current_user_leads.qualified.count,
      active_conversations: current_user_conversations.active.count, # Changed here
      recent_appointments: current_user.appointments.where("scheduled_at >= ?", Date.current).count
    }

    @recent_leads = current_user_leads.recent.limit(5)
    @active_conversations = current_user_conversations.active.includes(:lead, :assistant).limit(5) # Changed here
    @upcoming_appointments = current_user.appointments
                                        .where("scheduled_at >= ?", Time.current)
                                        .order(:scheduled_at)
                                        .limit(5)

    # Chart data for the last 30 days
    @leads_chart_data = leads_over_time_data
    @conversion_chart_data = conversion_funnel_data
  end

  def analytics
    @date_range = params[:date_range] || "30"
    start_date = @date_range.to_i.days.ago

    @analytics = {
      total_leads: current_user_leads.where("leads.created_at >= ?", start_date).count,
      qualified_leads: current_user_leads.qualified.where("leads.created_at >= ?", start_date).count,
      conversion_rate: calculate_conversion_rate(start_date),
      avg_lead_score: calculate_avg_lead_score(start_date),
      total_conversations: current_user_conversations.where("conversations.created_at >= ?", start_date).count, # Changed here
      avg_conversation_duration: calculate_avg_conversation_duration(start_date),
      assistant_performance: assistant_performance_data(start_date)
    }

    @charts_data = {
      leads_over_time: leads_over_time_data(start_date),
      conversion_funnel: conversion_funnel_data(start_date),
      sentiment_distribution: sentiment_distribution_data(start_date),
      source_breakdown: source_breakdown_data(start_date)
    }
  end

  private

  def leads_over_time_data(start_date = 30.days.ago)
    current_user_leads.where("leads.created_at >= ?", start_date)
                     .group("DATE(leads.created_at)")
                     .count
  end

  def conversion_funnel_data(start_date = 30.days.ago)
    leads = current_user_leads.where("leads.created_at >= ?", start_date)
    {
      "Total Leads" => leads.count,
      "Contacted" => leads.contacted.count,
      "Qualified" => leads.qualified.count,
      "Converted" => leads.converted.count
    }
  end

  def sentiment_distribution_data(start_date = 30.days.ago)
    # Correctly fetch transcripts through assistants and then conversations
    transcripts = Transcript.joins(conversation: :assistant)
                            .where(assistants: { user_id: current_user.id })
                            .where("conversations.created_at >= ?", start_date)

    {
      "Positive" => transcripts.where(sentiment: "positive").count,
      "Neutral" => transcripts.where(sentiment: "neutral").count,
      "Negative" => transcripts.where(sentiment: "negative").count
    }
  end

  def source_breakdown_data(start_date = 30.days.ago)
    current_user_leads.where("leads.created_at >= ?", start_date)
                     .group(:source)
                     .count
  end

  def calculate_conversion_rate(start_date)
    leads = current_user_leads.where("leads.created_at >= ?", start_date)
    return 0 if leads.count.zero?

    (leads.converted.count.to_f / leads.count * 100).round(2)
  end

  def calculate_avg_lead_score(start_date)
    current_user_leads.where("leads.created_at >= ?", start_date)
                     .where.not(score: nil)
                     .average(:score)
                     &.round(2) || 0
  end

  def calculate_avg_conversation_duration(start_date)
    duration = current_user_conversations.where("conversations.created_at >= ?", start_date) # Changed here
                          .where.not(duration: nil)
                          .average(:duration)

    return 0 unless duration
    (duration / 60.0).round(2) # Convert to minutes
  end

  def assistant_performance_data(start_date)
    current_user_assistants.includes(:leads, :conversations).map do |assistant|
      leads = assistant.leads.where("leads.created_at >= ?", start_date)
      conversations = assistant.conversations.where("conversations.created_at >= ?", start_date)

      {
        name: assistant.name,
        leads_generated: leads.count,
        qualified_leads: leads.qualified.count,
        avg_lead_score: leads.where.not(score: nil).average(:score)&.round(2) || 0,
        total_conversations: conversations.count,
        avg_conversation_duration: conversations.where.not(duration: nil).average(:duration)&./(60)&.round(2) || 0
      }
    end
  end

  # Helper method to get conversations for the current user through assistants
  def current_user_conversations
    Conversation.joins(:assistant).where(assistants: { user_id: current_user.id })
  end

  # Helper method to get leads for the current user through assistants
  def current_user_leads
    Lead.joins(:assistant).where(assistants: { user_id: current_user.id })
  end

  # Helper method to get assistants for the current user
  def current_user_assistants
    current_user.assistants
  end
end
