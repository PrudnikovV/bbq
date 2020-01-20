class Subscription < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, uniqueness: { scope: :event_id } ,
              format: /\A[\w\-.]+@[\w\-]+\.[\w\-.]+\z/, unless: -> { user.present? }
  validates :user, uniqueness: { scope: :event_id } , if: -> { user.present? }

  validate :unique_email, unless: -> { user.present? }
  validate :user_on_event, if: -> { user.present? }

  before_validation :email_downcase, on: :create


  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  private

    def email_downcase
      self.user_email.downcase!
    end

    def unique_email
      errors.add(:user_email, I18n.t('subscription.errors.email_exist') ) if User.where(email: user_email).exists?
    end

    def user_on_event
      errors.add(:user, I18n.t('subscription.errors.on_his_event') ) if user == event.user
    end
end
