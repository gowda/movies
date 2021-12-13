# frozen_string_literal: true

module SessionsHelper
  def current_user
    @current_user ||= User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def signin(user)
    session[:user_id] = user.id
  end

  def signout
    session.delete(:user_id)
  end
end
