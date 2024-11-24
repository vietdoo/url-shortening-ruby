class DecodingService
  def initialize(base_url, short_code, cache)
    @base_url = base_url
    @short_code = short_code
    @cache = cache
  end

  def decode_url
    cached_url = @cache.get(@short_code)
    return cached_url if cached_url

    url = Url.find_by(short_code: @short_code)

    if url.nil?
      return ApiResponse.new(status: :not_found, message: "URL not found.")
    end

    if url.time_expired <= Time.now
      return ApiResponse.new(status: :not_found, message: "URL has expired.")
    end

    response = ApiResponse.new(
      status: :ok,
      data: {
        original_url: url.original_url,
        short_url: "#{@base_url}/#{@short_code}",
        short_code: @short_code,
        time_expired: url.time_expired
      },
      message: "URL decoded successfully!"
    )

    @cache.put(@short_code, response)
    response
  end
end