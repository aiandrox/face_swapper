class PersonalPhotosController < ApplicationController
  before_action :set_personal_photo, only: %i[ show edit update destroy ]

  # GET /personal_photos
  def index
    @personal_photos = PersonalPhoto.all
  end

  # GET /personal_photos/1
  def show
  end

  # GET /personal_photos/new
  def new
    @personal_photo = PersonalPhoto.new
  end

  # GET /personal_photos/1/edit
  def edit
  end

  # POST /personal_photos
  def create
    @personal_photo = PersonalPhoto.new(personal_photo_params)


    if @personal_photo.save
      processed_icon = PersonalPhoto.process_icon(params[:personal_photo][:icon])
      @personal_photo.icon.attach(io: processed_icon, filename: "#{@personal_photo.id}_#{Time.zone.now.to_i}.png", content_type: "image/png")
      redirect_to @personal_photo, notice: "Personal photo was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /personal_photos/1
  def update
    if @personal_photo.update(personal_photo_params)
      if params[:personal_photo][:icon].present?
        processed_icon = PersonalPhoto.process_icon(params[:personal_photo][:icon])
        @personal_photo.icon.attach(io: StringIO.new(processed_icon), filename: "#{@personal_photo.id}_#{Time.zone.now.to_i}.png", content_type: "image/png")
      end
      redirect_to @personal_photo, notice: "Personal photo was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /personal_photos/1
  def destroy
    @personal_photo.destroy!
    redirect_to personal_photos_path, notice: "Personal photo was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_photo
      @personal_photo = PersonalPhoto.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def personal_photo_params
      params.expect(personal_photo: [ :name, :photo ])
    end
end
