class OriginalPhotosController < ApplicationController
  before_action :set_original_photo, only: %i[ show edit update destroy ]

  # GET /original_photos
  def index
    @original_photos = OriginalPhoto.all
  end

  # GET /original_photos/1
  def show
  end

  # GET /original_photos/new
  def new
    @original_photo = OriginalPhoto.new
  end

  # GET /original_photos/1/edit
  def edit
  end

  # POST /original_photos
  def create
    @original_photo = OriginalPhoto.new(original_photo_params)

    if @original_photo.save
      @original_photo.exec_rekognition
      redirect_to @original_photo, notice: "Original photo was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /original_photos/1
  def update
    if @original_photo.update(original_photo_params)
      @original_photo.exec_rekognition
      redirect_to @original_photo, notice: "Original photo was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /original_photos/1
  def destroy
    @original_photo.destroy!
    redirect_to original_photos_path, notice: "Original photo was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_original_photo
      @original_photo = OriginalPhoto.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def original_photo_params
      params.expect(original_photo: [ :photo ])
    end
end
