class AttachmentsController < ApplicationController
  before_action :find_attachment, only: [:destroy]
  before_action :must_be_author!, only: [:destroy]

  def destroy
    @attachment.destroy
  end

  private

  def find_attachment
    @attachment = Attachment.find(attachment_params)
  end

  def must_be_author!
    unless current_user.author_of?(@attachment.attachable)
      render json: { errors:"Only author can modify attachment" }, status: :method_not_allowed
    end
  end

  def attachment_params
    params.require(:id)
  end
end
