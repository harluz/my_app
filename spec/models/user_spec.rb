# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  # 名前とメール、パスワードが有効な状態であること
  it 'is valid with a name, email, and password' do
    user.valid?
    expect(user).to be_valid
  end

  # 名前が空白であれば無効な状態であること
  it 'is invalid without a name' do
    user = build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  # 名前が50文字以上であれば無効な状態であること
  it 'is invalid if the name are more than 50 characters' do
    user = build(:user, name: 'a' * 51)
    user.valid?
    expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  # メールが空白であれば無効な状態であること
  it 'is invalid without an email' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # メールが255文字以上であれば無効な状態であること
  it 'is invalid if the email are more than 255 characters' do
    user = build(:user, email: 'a' * 244 + '@example.com')
    user.valid?
    expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  # 重複したメールアドレスであれば無効な状態であること
  it 'is invalid with a duplicate email address' do
    other_user = build(:user, email: user.email)
    other_user.valid?
    expect(other_user.errors[:email]).to include('has already been taken')
  end

  # メールアドレスのフォーマットが正しければ有効な状態であること
  it 'is valid if the format of the email address is correct' do
    expect(build(:user, email: 'user@example.com')).to be_valid

    expect(build(:user, email: 'USER@foo.COM')).to be_valid

    expect(build(:user, email: 'A_US-ER@foo.bar.org')).to be_valid

    expect(build(:user, email: 'first.last@foo.jp')).to be_valid

    expect(build(:user, email: 'alice+bob@baz.cn')).to be_valid
  end

  # メールアドレスのフォーマットが不正であれば無効な状態であること
  it 'is valid if the format of the email address is incorrect' do
    expect(build(:user, email: 'user@example,com')).to_not be_valid

    expect(build(:user, email: 'user_at_foo.org')).to_not be_valid

    expect(build(:user, email: 'user.name@example.')).to_not be_valid

    expect(build(:user, email: 'foo@bar_baz.com')).to_not be_valid

    expect(build(:user, email: 'foo@bar+baz.comm')).to_not be_valid
  end

  # メールアドレスが小文字で保存されること
  it 'email addresses should be saved as lower-case' do
    user = create(:user, email: 'Foo@ExAMPle.CoM')
    expect(user.email).to eq user.email.downcase
  end
  # パスワードが空白であれば無効な状態であること
  it 'is invalid without a password' do
    user = build(:user, password: nil, password_confirmation: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  # パスワードが６文字以上であれば有効な状態であること
  it 'is invalid if the password are more than 6 characters' do
    user = build(:user, password: 'a' * 6, password_confirmation: 'a' * 6)
    user.valid?
    expect(user).to be_valid
  end

  # パスワードが５文字以下であれば無効な状態であること
  it 'is invalid if the password are less than 5 characters' do
    user = build(:user, password: 'a' * 5, password_confirmation: 'a' * 5)
    user.valid?
    expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
  end

  # passwordとpassword_confirmationが一致している時有効な状態である
  it 'is valid if a password and a password are equal' do
    expect(user.password).to eq user.password_confirmation
  end

  # passwordとpassword_confirmationが一致していない時無効な状態である
  it 'If a password and a password are not same' do
    user = build(:user, password_confirmation: 'foobaz')
    user.valid?
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end
end
