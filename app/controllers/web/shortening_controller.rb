module Web
  class ShorteningController < ApplicationController
    def index
      @url = Url.new
    end
  end
end