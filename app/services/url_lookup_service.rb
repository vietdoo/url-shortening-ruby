class UrlLookupService
  def initialize(short_code)
    @short_code = short_code
  end

  def find_url
    Url.find_by(short_code: @short_code)
  end
end