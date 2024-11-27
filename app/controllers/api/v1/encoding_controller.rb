module Api
  module V1
    class EncodingController < BaseController
      def encode
        json_params = JSON.parse(request.body.read)
        params.merge!(json_params)

        form_valid = UrlEncodeForm.new(url_params.merge(expiration_days: params[:url][:expiration_days].presence || 30)).valid

        if !form_valid.success?
          render json: ErrorSerializer.new(form_valid.message).as_json, status: :unprocessable_entity
          return
        end

        url = user_signed_in? ? current_user.urls.new(url_params) : Url.new(url_params)
        service = UrlEncodingService.new(url, url_params)
        response = service.encode

        if response.success?
          render json: UrlSerializer.new(response.data, "URL shortened successfully!").as_json, status: :ok
        else
          render json: ErrorSerializer.new(response.message).as_json, status: :unprocessable_entity 
        end
      end

      private

      def url_params
        params.require(:url).permit(:original_url, :short_code)
      end
    end
  end
end