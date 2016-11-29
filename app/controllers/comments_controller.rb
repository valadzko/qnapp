class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_commentable

  def index
    @comments = @commentable.comments
  end

  def create
    @comment = @commentable.comments.create(comments_params.merge(user: current_user))
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end
  end

end
