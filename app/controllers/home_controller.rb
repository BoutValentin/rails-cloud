class HomeController < ApplicationController

  def index
    @file = FileInfo.new
    @files = FileInfo.order(created_at: :asc).all
  end
end
