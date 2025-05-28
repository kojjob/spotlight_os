class DealRoom < ApplicationRecord
  belongs_to :lead
  belongs_to :user
  has_many :conversations, through: :lead

  enum stage: { initial_contact: 0, needs_analysis: 1, proposal: 2, negotiation: 3, closed_won: 4, closed_lost: 5 }

  def timeline_events
    events = conversations.flat_map do |c|
      [
        {
          type: :conversation,
          date: c.created_at,
          title: "Conversation with #{c.lead.name}",
          content: c.transcript&.content&.truncate(100)
        }
      ]
    end
    
    events.sort_by { |e| e[:date] }.reverse
  end

  def generate_ai_summary
    DealRoomSummaryService.new(self).generate_summary
  end
end