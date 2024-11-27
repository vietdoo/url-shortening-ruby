require 'ostruct'

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
      return OpenStruct.new(success?: false, message: "Shortcode already exists. Please try another one.")
    end

    if @url.save
      OpenStruct.new(success?: true, data: @url)
    else
      OpenStruct.new(success?: false, message: @url.errors.full_messages.join(", "))
    end
  end

  private

  def validate_expiration_days
    @expiration_days = @params[:expiration_days].presence || 30
    unless @expiration_days.to_s.match?(/^\d+$/)
      return OpenStruct.new(success: false, message: "Expiration days must be a valid number")
    end

    if @expiration_days.to_i <= 0 || @expiration_days.to_i > 30
      return OpenStruct.new(success: false, message: "Expiration days must be a positive number between 1 and 30")
    nil
    end
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