class UrlDecodingService
  def initialize(short_code)
    @short_code = short_code
  end

  def decode
    url = Url.find_by(short_code: @short_code)

    if url.nil?
      ApiResponse.new(status: :not_found, message: "URL not found.")
    elsif url.time_expired <= Time.now
      ApiResponse.new(status: :not_found, message: "URL has expired.")
    else
      ApiResponse.new(
        status: :ok,
        data: {
          original_url: url.original_url,
          short_url: "#{Rails.application.routes.url_helpers.root_url}#{url.short_code}",
          short_code: url.short_code,
          time_expired: url.time_expired,
        },
        message: "URL decoded successfully!"
      )
    end
  end
end