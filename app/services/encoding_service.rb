# app/services/url_encoding_service.rb
class EncodingService
  def initialize(base_url, shortened_url_result_path, original_url, short_code = nil, expiration_days = nil)
    @base_url = base_url
    @shortened_url_result_path = shortened_url_result_path
    @original_url = original_url
    @short_code = short_code
    @expiration_days = expiration_days
  end

  def encode_url()
  
    url = Url.new(original_url: @original_url)
    url.short_code = @short_code.presence || generate_unique_short_code
    url.time_init = Time.now
    url.time_expired = calculate_expiration_time

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