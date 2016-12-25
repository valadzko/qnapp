class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end

  def not_found
    respond_with '{"error":"not_found"}', status: :not_found
  end
end
