class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to root_url, flash: { notice: exception.message }
    else
     redirect_to root_url, flash: { notice: 'Please <a href="/auth/twitter">sign in</a> to access this page.'.html_safe }
    end
  end

  protected

  def render_404
    render :file => Rails.root.join("public/404.html").to_s, :layout => false, :status => 404
  end

  private

  def current_user
    @current_user ||= Traveller.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

end
