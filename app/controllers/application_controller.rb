class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def site_http_basic_authenticate_with
    return unless Rails.env.production?

    authenticate_or_request_with_http_basic("Application") do |name, password|
      name == Rails.application.credentials.dig(:http_basic_auth, :name) && password == Rails.application.credentials.dig(:http_basic_auth, :password)
    end
  end
end
