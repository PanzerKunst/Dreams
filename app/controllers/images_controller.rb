class ImagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :enforce_permission!, only: [:create, :destroy, :archive]
  before_filter :camp_id

  def index
    @images = Image.where(camp_id: @camp_id)

    # TODO
    puts "### index > @images:" + @images.to_s

  end

  def show
    image = Image.find_by_id(params[:id])
  end

  def create

    # TODO
    puts "### create > params[:attachment]:" + params[:attachment].to_s

    if params[:attachment].blank?
      flash[:alert] = t(:error_no_image_selected)
      redirect_to camp_images_path(camp_id: @camp_id)
      return
    end

    @image = Image.new(image_params)

    # TODO
    puts "### create > @image:" + @image.to_s

    @image.user_id = current_user.id

    # TODO
    puts "### create > @image.user_id:" + @image.user_id.to_s

    if @image.save

      # TODO
      puts "### create > redirect_to"

      redirect_to camp_images_path(camp_id: @camp_id)
    else

      # TODO
      puts "### create > render"

      render action: 'index'
    end
  end

  def destroy
    @image = Image.find_by_id(params[:id])
    @image.attachment = nil
    @image.save!
    @image.destroy!

    redirect_to camp_images_path(camp_id: @camp_id)
  end

  def enforce_permission!
    @camp = Camp.find(camp_id)

    if (@camp.creator != current_user) and (!current_user.admin)
      flash[:alert] = "#{t:security_cant_change_images_you_dont_own}"
      redirect_to camp_images_path(camp_id: camp_id)
    end
  end

  def camp_id
    @camp_id = params[:camp_id]
  end

  private

  def image_params
    params.permit(:attachment, :camp_id)
  end
end
