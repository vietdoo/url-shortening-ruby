require 'ostruct'

class UrlEncodingService
  def initialize(url, params)
    @url = url
    @params = params
  end

  def encode

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