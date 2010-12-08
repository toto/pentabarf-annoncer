class Backend::BackendController < ApplicationController
  
  AUTH = YAML::load_file(Rails.root.join('config','auth.yml'))
  

  layout 'backend'
  skip_before_filter :find_conference
  before_filter :authenticate_backend
  
  protected
  def authenticate_backend
    authenticate_with_http_basic do |username, password|
      AUTH &&
      AUTH[Rails.env.to_s] &&
      AUTH[Rails.env.to_s]['username'] == username.to_s &&
      AUTH[Rails.env.to_s]['password'] == password.to_s
    end
  end
  
end