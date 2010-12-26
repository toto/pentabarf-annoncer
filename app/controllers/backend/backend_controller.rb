class Backend::BackendController < ApplicationController
  AUTH_FILE = Rails.root.join('config','auth.yml')
  AUTH = YAML::load_file(AUTH_FILE)
  
  def index
    redirect_to backend_conferences_path
  end

  layout 'backend'
  skip_before_filter :find_conference
  before_filter :authenticate_backend
  
  protected
  def authenticate_backend
    authenticate_with_http_basic do |username, password|
      File.exist?(AUTH_FILE) &&
      AUTH &&
      AUTH[Rails.env.to_s] &&
      AUTH[Rails.env.to_s]['username'] == username.to_s &&
      AUTH[Rails.env.to_s]['password'] == password.to_s
    end
  end
  
end