class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_commentable, except: [:destroy]
  before_action :find_comment, only: [:destroy]
  after_action :publish_comment, only: [:create]

  respond_to :js

  authorize_resource

  def index
    respond_with(@comments = @commentable.comments)
  end

  def create
    respond_with(@comment = @commentable.comments.create(comments_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

  def comments_params
    params.require(:comment).permit(:content)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast( channel_name, rendering_params )
  end

  def channel_name
    id = @commentable.class == Question ? @commentable.id : @commentable.question.id
    "comments-for-question-page-#{id}"
  end

  def rendering_params
    @comment.as_json.merge(user_email: @comment.user.email).to_json
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
