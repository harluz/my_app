# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :responses, dependent: :nullify
  default_scope -> { order(created_at: :desc) }

  before_save :space_correction_english, :correction_japanese

  validates :comment, allow_blank: true, length: { maximum: 140 }
  validates :user_id, presence: true
  VALID_ENGLISH_REGEX = /\A[a-z]+[a-z ]*[a-z]?\z/.freeze
  validates :english, presence: true, length: { maximum: 50 },
                      format: { with: VALID_ENGLISH_REGEX }
  VALID_JAPANESE_REGEX = /\A[〜]?[ぁ-んァ-ン一-龥]+[ぁ-んァ-ン一-龥ー]*[[:punct:]]?\z/.freeze
  validates :japanese, presence: true, length: { maximum: 50 },
                       format: { with: VALID_JAPANESE_REGEX }
end
