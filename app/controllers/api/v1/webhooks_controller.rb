class Api::V1::WebhooksController < Api::V1::BaseController
  def create
    case params[:type]
    when "conversation_completed"
      handle_conversation_completed(params[:data])
    when "lead_updated"
      handle_lead_updated(params[:data])
    else
      render json: { error: "Unknown webhook type" }, status: :bad_request
    end
  end

  private

  def handle_conversation_completed(data)
    conversation = Conversation.find_by(id: data[:conversation_id])
    if conversation
      conversation.update(status: :completed, ended_at: Time.current)
      render json: { message: "Conversation marked as completed" }
    else
      render json: { error: "Conversation not found" }, status: :not_found
    end
  end

  def handle_lead_updated(data)
    lead = Lead.find_by(id: data[:lead_id])
    if lead
      lead.update(data[:attributes] || {})
      render json: { message: "Lead updated successfully" }
    else
      render json: { error: "Lead not found" }, status: :not_found
    end
  end
end
