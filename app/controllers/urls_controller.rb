class UrlsController < ApplicationController
  before_action :authenticate_user!, only: [:history]
  skip_before_action :verify_authenticity_token, only: [:encode, :decode]

  def new
    @url = Url.new
  end

  def encode
    @url = user_signed_in? ? current_user.urls.new(url_params) : Url.new(url_params)

    @url.short_code = params[:url][:short_code].presence || generate_unique_short_code
    @url.time_init = Time.now
    expiration_days = params[:url][:expiration_days].to_i
    @url.time_expired = Time.now + expiration_days.days

    if Url.exists?(short_code: @url.short_code)
      response = ApiResponse.new(
        status: :unprocessable_entity,
        message: "Shortcode already exists. Please try another one."
      )
      render json: response.to_h, status: response.status
    elsif @url.save
      response = ApiResponse.new(
        status: :ok,
        data: {
          original_url: @url.original_url,
          short_code: @url.short_code,
          time_expired: @url.time_expired,
          result_page: "#{request.base_url}#{shortened_url_result_path}?id=#{@url.hash_id}",
        },
        message: "URL shortened successfully!"
      )
      render json: response.to_h, status: response.status
    else
      response = ApiResponse.new(
        status: :unprocessable_entity,
        message: "Invalid URL. Please try again."
      )
      render json: response.to_h, status: response.status
    end
  end

  def decode
    begin
      @url = Url.find_by(short_code: decode_params[:short_code])
    rescue ActionController::ParameterMissing => e
      response = ApiResponse.new(
        status: :unprocessable_entity,
        message: "Missing parameter: #{e.param}. Please provide a valid short_code."
      )
      render json: response.to_h, status: :unprocessable_entity
      return
    end

    if @url && @url.time_expired > Time.now
      response = ApiResponse.new(
        status: :ok,
        data: { original_url: @url.original_url },
        message: "URL decoded successfully!"
      )
      render json: response.to_h, status: response.status
    else
      response = ApiResponse.new(
        status: :not_found,
        message: "URL not found or expired."
      )
      render json: response.to_h, status: response.status
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
      render :show, layout: "minimal"
    else
      render plain: "URL not found or expired"
    end
  end

  def history
    if user_signed_in?
      @urls = current_user.urls
    else
      flash[:error] = "You must be logged in to view your history."
      redirect_to new_user_session_path
    end
  end


  private

  def url_params
    params.require(:url).permit(:original_url, :short_code)
  end

  def decode_params
    params.require(:url).permit(:short_code)
  end

  def generate_unique_short_code
    loop do
      short_code = Array.new(rand(5..8)) { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample }.join
      break short_code unless Url.exists?(short_code: short_code)
    end
  end
end