class AttachmentsController < ApplicationController
  load_and_authorize_resource

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def attachment_params
    params.require(:id)
  end
end
