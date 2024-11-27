module Api
  module V1
    class EncodingController < BaseController
      def encode
        json_params = JSON.parse(request.body.read)
        params.merge!(json_params)
        expiration_days = params[:url][:expiration_days].presence || 30
        url = user_signed_in? ? current_user.urls.new(url_params) : Url.new(url_params)
        service = UrlEncodingService.new(url, url_params.merge(expiration_days: expiration_days))
        response = service.encode

        render json: response.to_h, status: response.status
      end

      private

      def url_params
        params.require(:url).permit(:original_url, :short_code)
      end
    end
  end
end