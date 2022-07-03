class HomeController < ApplicationController

  # Render root ("/")
  def index
    # File create to use in a form
    @file = FileInfo.new
    # Retrieve all file stores in ascending order
    @files = FileInfo.order(created_at: :asc).all
  end
end
