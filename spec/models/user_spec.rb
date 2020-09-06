# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # 名前とメール、性別、パスワードが有効な状態であること
  it 'is valid with a name, email, sex, and password'
  # 名前が空白であれば無効な状態であること
  it 'is invalid without a name' do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end
  # 名前が50文字以上であれば無効な状態であること
  it 'is invalid if the name are more than 50 characters' do
    user = User.new(name: 'a' * 51)
    user.valid?
    expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
  end
  # メールが空白であれば無効な状態であること
  it 'is invalid without an email'
  # メールが255文字以上であれば無効な状態であること
  it 'is invalid if the email are more than 255 characters'
  # 重複したメールアドレスであれば無効な状態であること
  it 'is invalid with a duplicate email address'
  # メールアドレスのフォーマットが正しければ有効な状態であること
  it 'is valid if the format of the email address is correct'
  # メールアドレスのフォーマットが不正であれば無効な状態であること
  it 'is valid if the format of the email address is incorrect'
  # パスワードが空白であれば無効な状態であること
  it 'is invalid without a password'
  # パスワードが６文字以上であれば有効な状態であること
  it 'is invalid if the password are more than 6 characters'
  # パスワードが５以下であれば無効な状態であること
  it 'is invalid if the password are less than 5 characters'
  # 性別が空白であれば無効な状態であること
  it 'is invalid without a sex'
end
