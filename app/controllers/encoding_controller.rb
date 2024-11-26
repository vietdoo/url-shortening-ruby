class EncodingController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:encode]

  def encode

    begin
      json_params = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      response = ApiResponse.new(status: :bad_request, message: "Invalid JSON")
      return render json: response.to_h, status: response.status
    end

    @url = user_signed_in? ? current_user.urls.new(url_params) : Url.new(url_params)
    
    validation_error = validate_expiration_days
    return render json: validation_error.to_h, status: validation_error.status if validation_error

    @url.short_code = params[:url][:short_code].presence || generate_unique_short_code
    @url.time_init = Time.now
    @url.time_expired = calculate_expiration_time

    response = get_api_response
    render json: response.to_h, status: response.status
    

  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def validate_expiration_days
    # Check if expiration_days is a valid number
    @expiration_days = params[:url][:expiration_days].presence || 30
    unless @expiration_days.to_s.match?(/^\d+$/)
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Expiration days must be a valid number"
      )
    end

    # Check if expiration_days is within the range 1–30
    if  @expiration_days.to_i <= 0 || @expiration_days.to_i > 30
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Expiration days must be a positive number between 1 and 30"
      )
    end

    nil
  end

  def get_api_response
    if @url.invalid?
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: @url.errors.full_messages.join(", ")
      )
    end

    if Url.exists?(short_code: @url.short_code)
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Shortcode already exists. Please try another one."
      )
    elsif @url.save
      ApiResponse.new(
        status: :ok,
        data: {
          original_url: @url.original_url,
          short_code: @url.short_code,
          time_expired: @url.time_expired,
          result_page: "#{request.base_url}#{shortened_url_result_path}?id=#{@url.hash_id}",
        },
        message: "URL shortened successfully!"
      )
    else
      ApiResponse.new(
        status: :unprocessable_entity,
        message: @url.errors.full_messages.join(", ")
      )
    end
  end
    

  def calculate_expiration_time
    Time.now + params[:url][:expiration_days].to_i.days
  end

  def generate_unique_short_code
    loop do
      short_code = Array.new(rand(5..8)) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join
      break short_code unless Url.exists?(short_code: short_code)
    end
  end
end