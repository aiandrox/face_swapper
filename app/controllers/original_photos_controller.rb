class OriginalPhotosController < ApplicationController
  before_action :site_http_basic_authenticate_with, only: %i[ index ]
  before_action :set_original_photo, only: %i[ show destroy ]

  # GET /original_photos
  def index
    @original_photos = OriginalPhoto.all
  end

  # GET /original_photos/1
  def show
  end

  # POST /original_photos
  def create
    @original_photo = OriginalPhoto.new(original_photo_params)

    if @original_photo.save
      @original_photo.exec_rekognition
      redirect_to @original_photo, notice: "画像を変換しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /original_photos/1
  def destroy
    @original_photo.destroy!
    redirect_to root_path, notice: "画像を削除しました", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_original_photo
      @original_photo = OriginalPhoto.find_by!(uuid: params.expect(:uuid))
    end

    # Only allow a list of trusted parameters through.
    def original_photo_params
      params.expect(original_photo: [ :photo ])
    end
end
