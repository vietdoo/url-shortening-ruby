class UrlsController < ApplicationController
  def index
    @urls = Url.all
  end

  def result
    @url = Url.find_by(hash_id: params[:id])
  end

  def show
    @url = Url.find_by(short_code: params[:short_code])

    if @url && @url.time_expired > Time.now
      @original_url = @url.original_url
      render :show, layout: "minimal"
    else
      render plain: "URL not found or expired"
    end
  end

end