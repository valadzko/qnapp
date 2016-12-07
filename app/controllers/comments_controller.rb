class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_commentable, except: [:destroy]
  before_action :find_comment, only: [:destroy]

  def index
    @comments = @commentable.comments
  end

  def create
    @comment = @commentable.comments.create(comments_params.merge(user: current_user))
  end

  def destroy
    @comment.destroy
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

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
