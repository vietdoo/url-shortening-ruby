class DecodingController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:decode]

  def decode
    unless decode_params[:short_code].present?
      response = ApiResponse.new(
        status: :unprocessable_entity,
        message: "Missing parameter: short_code. Please provide a valid short_code."
      )
      render json: response.to_h, status: :unprocessable_entity
      return
    end

    decode_service = DecodingService.new(request.base_url, decode_params[:short_code])
    response = decode_service.decode_url

    render json: response.to_h, status: response.status
  end

  private

  def decode_params
    params.require(:url).permit(:short_code)
  end
end