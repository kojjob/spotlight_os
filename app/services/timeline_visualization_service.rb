class TimelineVisualizationService
  def initialize(deal_room)
    @deal_room = deal_room
  end

  def generate_timeline_data
    {
      events: enhanced_timeline_events,
      milestones: deal_milestones,
      metrics: timeline_metrics,
      filters: available_filters
    }
  end

  private

  def enhanced_timeline_events
    events = []
    
    # Conversation events
    @deal_room.conversations.includes(:lead, :transcript).each do |conversation|
      events << {
        id: "conv_#{conversation.id}",
        type: 'conversation',
        date: conversation.created_at,
        title: "Call with #{conversation.lead.name}",
        description: conversation.transcript&.content&.truncate(150),
        duration: conversation.transcript&.duration || 0,
        sentiment: conversation.sentiment_score || 'neutral',
        participants: [conversation.lead.name],
        metadata: {
          lead_id: conversation.lead.id,
          conversation_id: conversation.id,
          call_outcome: conversation.outcome
        }
      }
    end

    # Deal stage changes
    stage_changes.each do |change|
      events << {
        id: "stage_#{change[:id]}",
        type: 'milestone',
        date: change[:date],
        title: "Stage: #{change[:to_stage].humanize}",
        description: "Deal moved from #{change[:from_stage].humanize} to #{change[:to_stage].humanize}",
        icon: stage_icon(change[:to_stage]),
        color: stage_color(change[:to_stage]),
        metadata: {
          from_stage: change[:from_stage],
          to_stage: change[:to_stage]
        }
      }
    end

    # Lead activities
    lead_activities.each do |activity|
      events << {
        id: "activity_#{activity[:id]}",
        type: 'activity',
        date: activity[:date],
        title: activity[:title],
        description: activity[:description],
        metadata: activity[:metadata]
      }
    end

    events.sort_by { |e| e[:date] }.reverse
  end

  def deal_milestones
    [
      {
        stage: 'initial_contact',
        title: 'First Contact',
        description: 'Initial conversation with lead',
        target_days: 0,
        color: '#3B82F6'
      },
      {
        stage: 'needs_analysis',
        title: 'Needs Analysis',
        description: 'Understanding requirements',
        target_days: 7,
        color: '#8B5CF6'
      },
      {
        stage: 'proposal',
        title: 'Proposal Sent',
        description: 'Formal proposal submitted',
        target_days: 14,
        color: '#F59E0B'
      },
      {
        stage: 'negotiation',
        title: 'Negotiation',
        description: 'Terms and pricing discussion',
        target_days: 21,
        color: '#EF4444'
      },
      {
        stage: 'closed_won',
        title: 'Deal Won',
        description: 'Successfully closed deal',
        target_days: 30,
        color: '#10B981'
      }
    ]
  end

  def timeline_metrics
    {
      total_events: enhanced_timeline_events.count,
      conversation_count: @deal_room.conversations.count,
      days_in_pipeline: (@deal_room.updated_at.to_date - @deal_room.created_at.to_date).to_i,
      average_response_time: calculate_average_response_time,
      engagement_score: calculate_engagement_score
    }
  end

  def available_filters
    {
      event_types: ['conversation', 'milestone', 'activity'],
      date_ranges: ['last_7_days', 'last_30_days', 'all_time'],
      participants: @deal_room.conversations.joins(:lead).pluck('leads.name').uniq
    }
  end

  def stage_changes
    # In a real implementation, you'd track stage changes in a separate table
    # For now, we'll simulate based on current stage and creation date
    changes = []
    current_stage_index = @deal_room.class.stages[@deal_room.stage]
    
    (0..current_stage_index).each do |index|
      stage_name = @deal_room.class.stages.key(index)
      changes << {
        id: "#{@deal_room.id}_#{index}",
        date: @deal_room.created_at + index.days,
        from_stage: index > 0 ? @deal_room.class.stages.key(index - 1) : nil,
        to_stage: stage_name
      }
    end
    
    changes
  end

  def lead_activities
    # Simulate lead activities based on conversations and timestamps
    activities = []
    
    @deal_room.conversations.each_with_index do |conv, index|
      if index > 0
        prev_conv = @deal_room.conversations[index - 1]
        time_gap = (conv.created_at - prev_conv.created_at) / 1.day
        
        if time_gap > 7
          activities << {
            id: "followup_#{conv.id}",
            date: conv.created_at - 1.day,
            title: 'Follow-up Scheduled',
            description: 'Scheduled follow-up call after extended silence',
            metadata: { conversation_id: conv.id }
          }
        end
      end
    end
    
    activities
  end

  def stage_icon(stage)
    {
      'initial_contact' => 'phone',
      'needs_analysis' => 'search',
      'proposal' => 'document',
      'negotiation' => 'handshake',
      'closed_won' => 'check-circle',
      'closed_lost' => 'x-circle'
    }[stage] || 'circle'
  end

  def stage_color(stage)
    {
      'initial_contact' => '#3B82F6',
      'needs_analysis' => '#8B5CF6',
      'proposal' => '#F59E0B',
      'negotiation' => '#EF4444',
      'closed_won' => '#10B981',
      'closed_lost' => '#6B7280'
    }[stage] || '#6B7280'
  end

  def calculate_average_response_time
    conversations = @deal_room.conversations.order(:created_at)
    return 0 if conversations.count < 2
    
    response_times = []
    conversations.each_cons(2) do |prev_conv, curr_conv|
      response_times << (curr_conv.created_at - prev_conv.created_at) / 1.hour
    end
    
    response_times.sum / response_times.count
  end

  def calculate_engagement_score
    # Simple engagement score based on conversation frequency and recency
    return 0 if @deal_room.conversations.empty?
    
    conversation_count = @deal_room.conversations.count
    days_since_last_contact = (Time.current - @deal_room.conversations.maximum(:created_at)) / 1.day
    
    base_score = [conversation_count * 10, 100].min
    recency_penalty = [days_since_last_contact * 2, 50].min
    
    [base_score - recency_penalty, 0].max
  end
end