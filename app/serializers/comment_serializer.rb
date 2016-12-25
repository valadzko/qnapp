class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :user_email, :commentable_type, :commentable_id

  def user_email
    object.user.email
  end
end
