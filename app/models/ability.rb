# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_ability : user_ability
    else
      guest_ability
    end
  end

  private

  def guest_ability
    can :read, :all
    cannot :read, Reward
  end

  def user_ability
    guest_ability
    can :read, Reward

    can [:create, :add_comment], [Question, Answer]
    can [:update, :destroy], [Question, Answer], author_id: user.id

    can [:like, :dislike], [Question, Answer] do |voteable|
      !user.author_of?(voteable) && user.votes.where(voteable: voteable).empty?
    end

    can :reset_vote, [Question, Answer] do |voteable|
      !user.author_of?(voteable) && user.votes.where(voteable: voteable).present?
    end

    can :mark_answer_as_best, Answer do |answer|
      !answer.best && user.author_of?(answer.question)
    end

    can :subscribe_new_answers, Question do |question|
      user.subscription_by_slug("new_answer", question).blank?
    end

    can :unsubscribe_new_answers, Question do |question|
      user.subscription_by_slug("new_answer", question).present?
    end

    can :subscribe_change_question, Question do |question|
      user.subscription_by_slug("change_question", question).blank?
    end

    can :unsubscribe_change_question, Question do |question|
      user.subscription_by_slug("change_question", question).present?
    end

    api_v1_ability
  end

  def admin_ability
    can :manage, :all
  end

  def api_v1_ability
    can [:me, :others], :profile
  end
end
