# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    # FIXME: redirect if already logged in
    redirect_to google_signin_url
  end

  def create
    user = authorizer.authorize!(params[:code])
    signin(user)

    redirect_to root_path
  end

  def destroy
    redirect_to root_path and return if current_user.nil?

    current_user.update!(access_token: nil, refresh_token: nil)
    signout

    redirect_to root_path
  end

  private

  def google_signin_url
    authorizer.url_for(request)
  end

  def authorizer
    @authorizer ||= Authorizer.new
  end
end
