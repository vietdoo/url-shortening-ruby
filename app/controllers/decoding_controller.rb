class DecodingController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:decode]

  rescue_from ActionController::ParameterMissing do |exception|
    return ApiResponse.new(
      status: :unprocessable_entity,
      message: "Missing parameter: short_code. Please provide a valid short_code."
    )
  end

  def decode

    begin
      json_params = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      return ApiResponse.new(status: :bad_request, message: "Invalid JSON")
    end

    unless decode_params[:short_code].present?
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Missing parameter: short_code. Please provide a valid short_code."
      )
    end

    
    
    @url = Url.find_by(short_code: decode_params[:short_code])



    if @url.nil?
      response = ApiResponse.new(status: :not_found, message: "URL not found.")
      return render json: response.to_h, status: response.status
    end

    if @url.time_expired <= Time.now
      response =  ApiResponse.new(status: :not_found, message: "URL has expired.")
      return render json: response.to_h, status: response.status
    end
    p "-" * 60
    p @url 
    p "-" * 60

    response = ApiResponse.new(
      status: :ok,
      data: {
        original_url: @url.original_url,
        short_url: "#{request.base_url}/#{@url.short_code}",
        short_code: @url.short_code,
        time_expired: @url.time_expired,
      },
      message: "URL decoded successfully!"
    )
    render json: response.to_h, status: response.status
  end

  private

  def decode_params
    params.require(:url).permit(:short_code)
  end
end