class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_devise_permitted_parameters, if: :devise_controller?
  after_filter :store_location    
  after_filter :clear_cache    


  helper_method :orgs

  def orgs
    Organization.all
  end

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/ || request.fullpath =~ /\/search_suggestions/ # 
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path 
  end

  def after_sign_in_path_for(resource)
    if current_user.try(:admin?)
      admin_path
    else
      # session[:previous_url] || user_path(current_user)
      user_path(current_user)
    end
  end

  def after_sign_up_path_for(resource)
    user_path(current_user)
  end

  def after_edit_path_for(resource)
    user_path(resource)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  def clear_cache
    if request.xhr?
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end 
  
  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation]
    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
    }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end
end
