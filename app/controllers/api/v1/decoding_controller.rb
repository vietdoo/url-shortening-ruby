module Api
  module V1
    class DecodingController < BaseController
      def decode
        json_params = JSON.parse(request.body.read)
        params.merge!(json_params)

        service = UrlDecodingService.new(decode_params[:short_code])
        response = service.decode

        render json: response.to_h, status: response.status
      end

      private

      def decode_params
        params.require(:url).permit(:short_code)
      end
    end
  end
end