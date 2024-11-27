module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token

      rescue_from JSON::ParserError do
        render json: ApiResponse.new(status: :bad_request, message: "Invalid JSON").to_h, status: :bad_request
      end
      
      rescue_from ActionController::ParameterMissing do |exception|
        render json: ApiResponse.new(
          status: :unprocessable_entity,
          message: "Missing parameter: #{exception.param}. Please provide a valid #{exception.param}."
        ).to_h, status: :unprocessable_entity
      end

      

    end
  end
end