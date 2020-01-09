class Comment < ApplicationRecord
  validates :event, presence: true
  belongs_to :event
  belongs_to :user
end
