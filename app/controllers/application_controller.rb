class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
    def redirect_back_or(path)
      redirect_to :back
      rescue ActionController::RedirectBackError
      redirect_to path
    end
end
