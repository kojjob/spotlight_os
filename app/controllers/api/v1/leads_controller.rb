class Api::V1::LeadsController < Api::V1::BaseController
  def create
    lead = Lead.new(lead_params)
    
    if lead.save
      render json: {
        lead: lead,
        message: 'Lead created successfully'
      }, status: :created
    else
      render json: {
        errors: lead.errors,
        message: 'Failed to create lead'
      }, status: :unprocessable_entity
    end
  end

  def update
    lead = Lead.find(params[:id])
    
    if lead.update(lead_update_params)
      render json: {
        lead: lead,
        message: 'Lead updated successfully'
      }
    else
      render json: {
        errors: lead.errors,
        message: 'Failed to update lead'
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lead not found' }, status: :not_found
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :company, :source, :assistant_id)
  end

  def lead_update_params
    params.require(:lead).permit(:status, :score, :qualified, :metadata)
  end
end
