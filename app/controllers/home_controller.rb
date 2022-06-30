class HomeController < ApplicationController

  def index
    @file = FileInfo.new
    @files = FileInfo.all
  end
end
