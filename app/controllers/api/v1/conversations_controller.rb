class Api::V1::ConversationsController < Api::V1::BaseController
  def create
    conversation = Conversation.new(conversation_params)

    if conversation.save
      render json: {
        conversation: conversation,
        message: "Conversation created successfully"
      }, status: :created
    else
      render json: {
        errors: conversation.errors,
        message: "Failed to create conversation"
      }, status: :unprocessable_entity
    end
  end

  def update
    conversation = Conversation.find(params[:id])

    if conversation.update(conversation_update_params)
      render json: {
        conversation: conversation,
        message: "Conversation updated successfully"
      }
    else
      render json: {
        errors: conversation.errors,
        message: "Failed to update conversation"
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Conversation not found" }, status: :not_found
  end

  private

  def conversation_params
    params.require(:conversation).permit(:lead_id, :assistant_id, :status, :source)
  end

  def conversation_update_params
    params.require(:conversation).permit(:status, :duration, :sentiment_score, :ended_at)
  end
end
