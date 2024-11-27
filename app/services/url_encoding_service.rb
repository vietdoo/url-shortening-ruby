class UrlEncodingService
  def initialize(url, params)
    @url = url
    @params = params
  end

  def encode
    validation_error = validate_expiration_days
    return validation_error if validation_error

    @url.short_code = @params[:short_code].presence || generate_unique_short_code
    @url.time_init = Time.now
    @url.time_expired = calculate_expiration_time

    if Url.exists?(short_code: @url.short_code)
        return ApiResponse.new(
            status: :unprocessable_entity,
            message: "Shortcode already exists. Please try another one."
        )
    end

    if @url.save
      ApiResponse.new(
        status: :ok,
        data: {
          original_url: @url.original_url,
          short_code: @url.short_code,
          time_expired: @url.time_expired,
          result_page: "#{@params[:request_base_url]}#{Rails.application.routes.url_helpers.web_shortened_url_result_path}?id=#{@url.hash_id}",
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

  private

  def validate_expiration_days
    @expiration_days = @params[:expiration_days].presence || 30
    unless @expiration_days.to_s.match?(/^\d+$/)
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Expiration days must be a valid number"
      )
    end

    if @expiration_days.to_i <= 0 || @expiration_days.to_i > 30
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Expiration days must be a positive number between 1 and 30"
      )
    end
    nil
  end

  def calculate_expiration_time
    Time.now + @params[:expiration_days].to_i.days
  end

  def generate_unique_short_code
    loop do
      short_code = Array.new(rand(5..8)) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join
      break short_code unless Url.exists?(short_code: short_code)
    end
  end
end