class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_commentable

  def index
    @comments = @commentable.comments
    respond_to do |format|
      format.json { render json: {commentable_id: @commentable.id, comments: @comments } }
    end
  end

  def create
    #todo can be created with issues
    @comment = @commentable.comments.create(comments_params.merge(user: current_user))
    respond_to do |format|
      format.json { render json: {commentable_id: @commentable.id, comment: @comment } }
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:content)
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end
  end

end
