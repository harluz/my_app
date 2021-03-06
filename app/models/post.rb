# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  before_save :space_correction_english, :correction_japanese

  validates :user_id, presence: true
  # アルファベットの小文字のみ許可する
  VALID_ENGLISH_REGEX = /\A[a-z]+[a-z ]*[a-z]?\z/.freeze
  validates :english, presence: true, length: { maximum: 50 },
                      format: { with: VALID_ENGLISH_REGEX }
  VALID_JAPANESE_REGEX = /\A[〜]?[ぁ-んァ-ン一-龥]+[ぁ-んァ-ン一-龥ー]*[[:punct:]]?\z/.freeze
  validates :japanese, presence: true, length: { maximum: 50 },
                       format: { with: VALID_JAPANESE_REGEX }
  mount_uploader :image, ImageUploader
  validates :image, presence: true
  validates :comment, allow_blank: true, length: { maximum: 140 }
end
