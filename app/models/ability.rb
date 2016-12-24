class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :upvote, :downvote, :resetvote, to: :vote

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end
    can :accept, Answer do |answer|
      answer.question.user_id == user.id
    end
    can :vote, [Answer, Question] do |obj|
      !user.author_of?(obj)
    end
    can [:me, :all], User
  end

  def admin_abilities
    can :manage, :all
  end
end
