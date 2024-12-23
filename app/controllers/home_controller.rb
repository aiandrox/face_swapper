class HomeController < ApplicationController
  def index
    @original_photo = OriginalPhoto.new
  end
end
