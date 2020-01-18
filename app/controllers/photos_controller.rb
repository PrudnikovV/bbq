class PhotosController < ApplicationController
  before_action :set_photo, only: [:destroy]
  before_action :set_event, only: [:create, :destroy]


  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user
    if @new_photo.save
      notify_subscribers_photo(@event, @new_photo)
      redirect_to @event, notice: I18n.t('controllers.photos.created')
    else
      render 'events/show', alert: I18n.t('controllers.photos.error')
    end
  end

  def destroy
    message = { notice: I18n.t('controllers.photos.destroyed') }

    if current_user_can_edit?(@photo)
      @photo.destroy
    else
      message = { alert: I18n.t('controllers.photos.error') }

      redirect_to @event, message
    end
  end

  private

  def notify_subscribers_photo(event, add_photo)
    all_emails = (event.subscriptions.where.not(user_id: current_user.user_id).map(&:user_email) + [event.user.email]).uniq
    all_emails.each do |mail|
      EventMailer.photo(event, add_photo, mail).deliver_now
    end
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end
    # Never trust parameters from the scary internet, only allow the white list through.
  def photo_params
    params.fetch(:photo, {}).permit(:photo)
  end
end
