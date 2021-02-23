# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:order) { FactoryBot.create(:order) }
  # 有効な場合
  context 'when to succeed' do
    # 全て有効な状態
    # 　正常なuser_idなら有効な状態である
    it 'is valid with orders test data' do
      expect(order).to be_valid
    end

    # englishがアルファベットであれば有効な状態である

    # 　englishが50文字以下であれば有効である
    it 'is valid if the english is 50 characters or less' do
      expect(order).to be_valid
    end

    # englishが1文字以上であれば有効な状態である
    it 'If english is one or more characters, it is in a valid state' do
      expect(build(:order, english: 'a')).to be_valid
    end
    # 　englishに半角スペースが二つ以上連続していれば一つに変換し、有効な状態である
    it 'is invalid if there are two or more consecutive spaces in english' do
      order.english = 'hello  world'
      order.save
      expect(order.english).to eq 'hello world'
    end
    # 　englishが最後がスペースがあれば削除し、有効な状態である
    it 'is invalid if there is a space at the end of english' do
      order.english = 'hello '
      order.save
      expect(order.english).to eq 'hello'
    end
    # japaneseが日本文字であれば有効な状態である

    # japaneseの先頭が記号でも有効である
    it "It is also valid if the beginning of japanese is '~'" do
      expect(build(:order, japanese: '〜について')).to be_valid
    end

    # japaneseに「ー」が二つ以上連続していれば一つに変換し、有効な状態である
    it "If two or more 'ー' are consecutive in japanese, it is converted to one and it is in a valid state." do
      order.japanese = 'デーータ'
      order.save
      expect(order.japanese).to eq 'データ'
    end
    # 　japaneseが50文字以下であれば有効である
    it 'is valid if the japanese is 50 characters or less' do
      expect(order).to be_valid
    end

    # コメントが空でも有効な状態である
    it 'is valid if the comment is empty' do
      expect(build(:order, comment: '')).to be_valid
    end

    # コメントがnilでも有効な状態である
    it 'is valid if the comment is nil' do
      expect(build(:order, comment: nil)).to be_valid
    end
    # 　コメントが140文字以下であれば有効である
    it 'is valid if the comment is 140 characters or less' do
      expect(build(:order, comment: 'a' * 140)).to be_valid
    end
  end

  # 無効な場合
  context 'when to fail' do
    # 　englishが50文字以上であれば無効な状態である
    it 'is invalid if the english are more than 50 characters' do
      expect(build(:order, english: 'a' * 51)).to_not be_valid
    end

    # 　englishが大文字であれば無効な状態である
    it 'is invalid if the english is uppercase' do
      expect(build(:order, english: 'HELLO')).to_not be_valid
    end
    # 　englishが日本語であれば無効な状態である
    it 'is invalid if the english is japanese' do
      expect(build(:order, english: 'こんにちわ')).to_not be_valid
    end
    # 　englishが空白であれば無効な状態である
    it 'is invalid without an english' do
      expect(build(:order, english: '')).to_not be_valid
    end

    # 　englishが先頭がスペースであれば無効な状態である
    it 'is invalid if there is a space at the begginning of english' do
      expect(build(:order, english: ' hello')).to_not be_valid
    end

    # 　englishに「'」が含まれていれば無効な状態である
    it 'is invalid if english contains single quotation' do
      expect(build(:order, english: "i'm")).to_not be_valid
    end

    # 　japaneseが50文字以上であれば無効な状態である
    it 'is invalid if the japanese are more than 50 characters' do
      expect(build(:order, japanese: 'a' * 51)).to_not be_valid
    end

    # 　japaneseがアルファベットであれば無効な状態である
    it 'is invalid if the japanese is english' do
      expect(build(:order, japanese: 'hello')).to_not be_valid
    end

    # 　japaneseが先頭がスペースであれば無効な状態である
    it 'is invalid if there is a space at the begginning of japanese' do
      expect(build(:order, japanese: ' こんにちわ')).to_not be_valid
    end
    # 　japaneseが最後がスペースであれば無効な状態である
    it 'is invalid if there is a space at the end of japanese' do
      expect(build(:order, japanese: 'こんにちわ ')).to_not be_valid
    end
    # 　japaneseの先頭に記号が連続する場合、無効である
    it 'Invalid if the symbol is consecutive at the beginning of japanese' do
      expect(build(:order, japanese: '〜〜について')).to_not be_valid
    end
    # japaneseの最後に記号が連続する場合、無効である
    it 'Invalid if there are consecutive symbols at the end of japanese' do
      expect(build(:order, japanese: 'について〜〜')).to_not be_valid
    end
    # japaneseの中間に記号を使用している場合、無効である
    it 'invalid if symbol is used in the middle of japanese' do
      expect(build(:order, japanese: 'こんに、ちわ')).to_not be_valid
    end

    # japaneseが記号一文字である場合、無効である
    it 'invalid if japanese is a single symbol' do
      expect(build(:order, japanese: '〜')).to_not be_valid
    end
    # 　japaneseが空白であれば無効な状態である
    it 'is invalid without an japanese' do
      expect(build(:order, japanese: '')).to_not be_valid
    end

    # コメントは140文字以上は無効である
    it 'is invalid if the comment are more than 140 characters' do
      expect(build(:order, comment: 'a' * 141)).to_not be_valid
    end

    # 　user_idが空白であれば無効である
    it 'is invalid without an user_id' do
      expect(build(:order, user_id: nil)).to_not be_valid
    end
  end

  describe 'sort by latest' do
    let!(:day_before_yesterday) { FactoryBot.create(:order, :day_before_yesterday) }
    let!(:now) { FactoryBot.create(:order, :now) }
    let!(:yesterday) { FactoryBot.create(:order, :yesterday) }

    it 'succeeds' do
      expect(Order.first).to eq now
    end
  end
end
