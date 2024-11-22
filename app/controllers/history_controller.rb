class HistoryController < ApplicationController
  before_action :authenticate_user!

  def index
    @urls = current_user.urls
  end
end