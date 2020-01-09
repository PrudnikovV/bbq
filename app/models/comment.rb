class Comment < ApplicationRecord
  validates :event
  belongs_to :event
  belongs_to :user
end
