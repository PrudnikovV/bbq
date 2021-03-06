class Event < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user
  has_many :photos

  validates :title, presence: true, length: {maximum: 255}
  validates :address, presence: true
  validates :datetime, presence: true

  def visitors
    (subscribers + [user]).uniq
  end

  def visitors_emails
      (subscriptions.map(&:user_email) + [user.email]).uniq
  end

  def pincode_valid?(pin2chek)
    pincode == pin2chek
  end
end
