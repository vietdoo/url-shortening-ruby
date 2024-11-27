class UrlSerializer
  def initialize(url, message = nil)
    @url = url
    @message = message
  end

  def as_json(*)
    
    {
      status: :ok,
      message: @message,
      data: {
        original_url: @url.original_url,
        short_code: @url.short_code,
        short_url: "#{Rails.application.routes.url_helpers.root_url}#{@url.short_code}",
        time_expired: @url.time_expired,
        result_page: "#{Rails.application.routes.url_helpers.shortened_url_result_path}?id=#{@url.hash_id}"
      }
      
    }
  end
end