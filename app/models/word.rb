# frozen_string_literal: true

class Word < ApplicationRecord
  # has_one :order

  validates :english, presence: true, length: { maximum: 50 }
  validates :japanese, presence: true, length: { maximum: 50 }
end
