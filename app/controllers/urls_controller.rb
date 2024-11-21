class UrlsController < ApplicationController
  def new
    @url = Url.new
  end

  def encode
    @url = Url.new(url_params)
    @url.short_code = SecureRandom.hex(5)
    @url.time_init = Time.now
    @url.time_expired = Time.now + 30.days

    if @url.save
      redirect_to result_path(short_code: @url.short_code)
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  def decode
    @url = Url.find_by(short_code: params[:short_code])

    if @url && @url.time_expired > Time.now
      render json: { original_url: @url.original_url }, status: :ok
    else
      render json: { error: "URL not found or expired" }, status: :not_found
    end
  end

  def index
    @urls = Url.all
  end

  def result
    @url = Url.find_by(short_code: params[:short_code])
  end

  def show
    @url = Url.find_by(short_code: params[:short_code])

    if @url && @url.time_expired > Time.now
      render plain: @url.original_url
    else
      render plain: ""
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end