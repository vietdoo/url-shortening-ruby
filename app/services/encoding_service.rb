# app/services/url_encoding_service.rb
class EncodingService
  def initialize(base_url, shortened_url_result_path, original_url, short_code = nil, expiration_days = nil)
    @base_url = base_url
    @shortened_url_result_path = shortened_url_result_path
    @original_url = original_url
    @short_code = short_code
    @expiration_days = expiration_days.presence || 30
  end

  def encode_url()

    validation_error = validate_expiration_days
    return validation_error if validation_error
  
    url = Url.new(original_url: @original_url)
    url.short_code = @short_code.presence || generate_unique_short_code
    url.time_init = Time.now
    url.time_expired = calculate_expiration_time

    if url.invalid?
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: url.errors.full_messages.join(", ")
      )
    end

    if Url.exists?(short_code: url.short_code)
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Shortcode already exists. Please try another one."
      )
    elsif url.save
      ApiResponse.new(
        status: :ok,
        data: {
          original_url: url.original_url,
          short_code: url.short_code,
          time_expired: url.time_expired,
          result_page: "#{@base_url}#{@shortened_url_result_path}?id=#{url.hash_id}",
        },
        message: "URL shortened successfully!"
      )
    else
      ApiResponse.new(
        status: :unprocessable_entity,
        message: url.errors.full_messages.join(", ")
      )
    end
  end

  private

  def validate_expiration_days
    # Check if expiration_days is a valid number
    unless @expiration_days.to_s.match?(/^\d+$/)
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Expiration days must be a valid number"
      )
    end

    # Check if expiration_days is within the range 1–30
    if @expiration_days.to_i <= 0 || @expiration_days.to_i > 30
      return ApiResponse.new(
        status: :unprocessable_entity,
        message: "Expiration days must be a positive number between 1 and 30"
      )
    end

    nil
  end
    

  def calculate_expiration_time
    Time.now + @expiration_days.to_i.days
  end

  def generate_unique_short_code
    loop do
      short_code = Array.new(rand(5..8)) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join
      break short_code unless Url.exists?(short_code: short_code)
    end
  end
end