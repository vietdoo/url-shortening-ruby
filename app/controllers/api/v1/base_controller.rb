

module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token

      rescue_from JSON::ParserError do
        render json: ErrorSerializer.new("Invalid JSON").as_json, status: :bad_request
      end
      
      rescue_from ActionController::ParameterMissing do |exception|
        render json: ErrorSerializer.new("Missing parameter: #{exception.param}. Please provide a valid #{exception.param}.").as_json, status: :unprocessable_entity
      end

    end
  end
end