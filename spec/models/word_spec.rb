# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Word, type: :model do
  # 有効な場合
  # 英語
  # 　50文字であれば有効な状態である
  # 　アルファベットであれば有効な状態である
  # 　空白でなければ有効な状態である
  # 日本語
  # 　50文字であれば有効な状態である
  # 　日本語であれば有効な状態である
  # 　空白でなければ有効な状態である
end
