class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions

  validates :name, presence: true, length: {maximum: 35}

  validates :email, length: {maximum: 255}
  validates :email, uniqueness: true
  validates :email, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/

  before_validation :set_name, :email_downcase, on: :create

  mount_uploader :avatar, AvatarUploader

  after_create_commit :link_subscriptions

  private

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
      .update_all(user_id: self.id)
  end

  def email_downcase
    self.email.downcase!
  end

  def set_name
    self.name = "Товарисч №#{rand(777)}" if self.name.blank?
  end
end
