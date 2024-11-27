module Api
  module V1
    class DecodingController < BaseController
      def decode
        json_params = JSON.parse(request.body.read)
        params.merge!(json_params)

        service = UrlDecodingService.new(decode_params[:short_code])
        response = service.decode

        if response.success?
          render json: UrlSerializer.new(response.data, "URL decoded successfully!").as_json, status: :ok
        else
          render json: ErrorSerializer.new(response.message).as_json, status: response.status
        end
      end

      private

      def decode_params
        params.require(:url).permit(:short_code)
      end
    end
  end
end