class Subscription < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event

  validates :event, presence: true
  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: /\A[\w\-.]+@[\w\-]+\.[\w\-.]+\z/, unless: -> { user.present? }

  validates :user, uniqueness: { scope: :event_id } , if: -> { user.present? }
  validates :user_email, uniqueness: { scope: :event_id } , unless: -> { user.present? }
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
end