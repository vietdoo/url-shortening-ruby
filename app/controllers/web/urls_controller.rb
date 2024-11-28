module Web
  class UrlsController < ApplicationController
    def index
      @urls = Url.all
    end

    def result
      @url = Url.find_by(hash_id: params[:id])
    end

    def show
      service = UrlLookupService.new(params[:short_code])
      @url = service.find_url

      if @url && @url.time_expired > Time.now
        @original_url = @url.original_url
        # Option 1: Render show page (count down)
        # render :show, layout: "minimal"

        # Option 2: Redirect to original_url
        redirect_to @original_url, allow_other_host: true
      else
        # render plain: "URL not found or expired"
        # render not_found_method
        render :file => "#{Rails.root}/public/404.html", layout: false, status: 404
      end
    end
  end
end