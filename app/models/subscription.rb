class Subscription < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, uniqueness: { scope: :event_id } ,
              format: /\A[\w\-.]+@[\w\-]+\.[\w\-.]+\z/, unless: -> { user.present? }
  validates :user, uniqueness: { scope: :event_id } , if: -> { user.present? }

  validate :unique_email, unless: -> { user.present? }

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.user_email
    else
      super
    end
  end

  private
    def unique_email
      errors.add(:user_email, I18n.t('subscription.errors.email_exist') ) if User.where(email: user_email.downcase).exists?
    end
end
