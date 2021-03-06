# encoding: utf-8

class SessionsController < ApplicationController
  skip_before_filter :authenticate!

  def create
    user = User.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    user ||= User.create_with_auth(auth_hash)
    session[:user_id] = user.id

    redirect_to session.delete(:return_to) and return if session[:return_to]
    redirect_to root_path
  end

  def logged_in
    render :json => { logged_in: !session[:user_id].nil? }
  end

  def failure
    redirect_to :root, :notice => 'Para interagir é preciso fazer login com o facebook'
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
