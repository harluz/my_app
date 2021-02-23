# frozen_string_literal: true

class Response < ApplicationRecord
  belongs_to :user
  belongs_to :order
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :order_id, presence: true
  mount_uploader :image, ImageUploader
  validates :image, presence: true
  validates :comment, allow_blank: true, length: { maximum: 140 }
end
