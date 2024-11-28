class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern


  def not_found_method
    render :file => "#{Rails.root}/public/404.html", layout: false, status: 404
  end
end
