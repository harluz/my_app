# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response, type: :model do
  let!(:response) { FactoryBot.create(:response) }
  # 有効な状態
  context 'when to succeed' do
    # 　user_idがあれば有効な状態
    # 　order_idがあれば有効な状態
    # 　imageがあれば有効な状態
    it 'is valid with responses test date' do
      expect(response).to be_valid
    end

    # コメントが空でも有効な状態である
    it 'is valid if the comment is empty' do
      expect(build(:response, comment: '')).to be_valid
    end

    # コメントがnilでも有効な状態である
    it 'is valid if the comment is nil' do
      expect(build(:response, comment: nil)).to be_valid
    end
    # 　コメントが140文字以下であれば有効である
    it 'is valid if the comment is 140 characters or less' do
      expect(build(:response, comment: 'a' * 140)).to be_valid
    end
  end

  context 'when to fail' do
    # 　user_idがなければ無効な状態
    it 'is invalid without an user_id' do
      expect(build(:response, user_id: nil)).to_not be_valid
    end
    # 　order_idがなければ無効な状態
    it 'is invalid without an order_id' do
      expect(build(:response, order_id: nil)).to_not be_valid
    end
    # 　imageがnilであれば無効な状態
    it 'is invalid without an image' do
      expect(build(:response, image: nil)).to_not be_valid
    end
    # 　imageが空であれば無効な状態
    it 'is invalid without an image' do
      expect(build(:response, image: '')).to_not be_valid
    end
    # 　commentが140文字以上であれば無効な状態
    it 'is invalid if the comment are more than 140 characters' do
      expect(build(:response, comment: 'a' * 141)).to_not be_valid
    end
  end

  describe 'sort by latest' do
    let!(:day_before_yesterday) { FactoryBot.create(:response, :day_before_yesterday) }
    let!(:now) { FactoryBot.create(:response, :now) }
    let!(:yesterday) { FactoryBot.create(:response, :yesterday) }

    it 'succeeds' do
      expect(Response.first).to eq now
    end
  end
end
