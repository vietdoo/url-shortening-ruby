class UrlsController < ApplicationController
  def new
    @url = Url.new
  end

  def encode
    @url = Url.new(url_params)
    @url.short_code = params[:url][:short_code].presence || generate_unique_short_code
    @url.time_init = Time.now
    expiration_days = params[:url][:expiration_days].to_i
    @url.time_expired = Time.now + expiration_days.days

    if Url.exists?(short_code: @url.short_code)
      flash[:error] = "Shortcode already exists. Please try another one."
      redirect_to shortening_url_path
    elsif @url.save
      redirect_to shortened_url_result_path(id: @url.hash_id)
    else
      redirect_to shortening_url_path
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
    @url = Url.find_by(hash_id: params[:id])
  end

  def show
    @url = Url.find_by(short_code: params[:short_code])

    if @url && @url.time_expired > Time.now
      @original_url = @url.original_url
      render :show
    else
      render plain: "URL not found or expired"
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url, :short_code)
  end

  def generate_unique_short_code
    loop do
      short_code = Array.new(rand(5..8)) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join
      break short_code unless Url.exists?(short_code: short_code)
    end
  end
end