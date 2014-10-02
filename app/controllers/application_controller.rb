class ApplicationController < ActionController::Base
  protect_from_forgery

  class UnauthorizedException < Exception
  end

  def render_unauthorized
    redirect_to unauthorized_path
  end

  def render_403
    respond_to do |format|
      format.html { render '403', layout: false }
    end
  end

  rescue_from UnauthorizedException, with: :render_unauthorized

  before_action :http_basic_authenticate if Rails.application.config.basic_auth
  before_action :authenticate, expect: :render_403

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.config.auth_username && password == Rails.application.config.auth_password
    end
  end

  def index
  end

  #Utility
  def popout_or_detail_layout?
    (params[:'layout']) ? params[:'layout'] :
      (params[:'popout'].nil? || params[:'popout'] == false.to_s) ? false :
        'popout'
  end

  def authenticate
    # custom authentication logic
  end
end
