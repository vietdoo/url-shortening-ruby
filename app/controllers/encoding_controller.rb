class EncodingController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:encode]

  def encode

    begin
      json_params = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      response = ApiResponse.new(status: :bad_request, message: "Invalid JSON")
      return render json: response.to_h, status: response.status
    end

    encoding_service = EncodingService.new(
        request.base_url, 
        shortened_url_result_path, 
        url_params[:original_url], 
        params[:url][:short_code], 
        params[:url][:expiration_days]
    )

    response = encoding_service.encode_url

    render json: response.to_h, status: response.status
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end