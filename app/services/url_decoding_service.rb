require 'ostruct'

class UrlDecodingService
  def initialize(short_code)
    @short_code = short_code
  end

  def decode
    url = Url.find_by(short_code: @short_code)

    if url.nil?
      OpenStruct.new(success?: false, message: "URL not found.", status: :not_found)
    elsif url.time_expired <= Time.now
      OpenStruct.new(success?: false, message: "URL has expired.", status: :not_found)
    else
      OpenStruct.new(success?: true, data: url)
    end
  end
end