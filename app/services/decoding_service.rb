class DecodingService
  def initialize(base_url, short_code)
    @base_url = base_url
    @short_code = short_code
  end

  def decode_url
    url = Url.find_by(short_code: @short_code)

    if url.nil?
      return ApiResponse.new(status: :not_found, message: "URL not found.")
    end

    if url.time_expired <= Time.now
      return ApiResponse.new(status: :not_found, message: "URL has expired.")
    end

    ApiResponse.new(
      status: :ok,
      data: {
        original_url: url.original_url,
        short_url: "#{@base_url}/#{@short_code}",
        short_code: @short_code,
        time_expired: url.time_expired,
      },
      message: "URL decoded successfully!"
    )
  end
end
