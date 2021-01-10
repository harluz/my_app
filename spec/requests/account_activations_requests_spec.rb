# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccountActivationsRequests', type: :request do
  let!(:user) { FactoryBot.create(:user, activated: false) }

  # 正しいトークンと間違ったemailの場合
  context 'when user sends right token and wrong email' do
    before do
      get edit_account_activation_path(
        user.activation_token,
        email: 'wrong'
      )
    end

    # ログインに失敗する
    it 'fails login' do
      expect(is_logged_in?).to be_falsy
    end

    it 'redirect to root url' do
      expect(response).to redirect_to root_url
    end

    it 'returns a 302 response' do
      expect(response).to have_http_status(302)
    end
  end

  # 間違ったトークンと正しいemailの場合
  context 'when user sends wrong token and right email' do
    before do
      get edit_account_activation_path(
        'wrong',
        email: user.email
      )
    end

    # ログインに失敗する
    it 'fails login' do
      expect(is_logged_in?).to be_falsy
    end

    it 'redirect to root url' do
      expect(response).to redirect_to root_url
    end

    it 'returns a 302 response' do
      expect(response).to have_http_status(302)
    end
  end

  # トークンとemailが間違えている場合
  context 'when both token and email are wrong' do
    before do
      get edit_account_activation_path(
        'wrong',
        email: 'wrong'
      )
    end

    # ログインに失敗する
    it 'fails login' do
      expect(is_logged_in?).to be_falsy
    end

    it 'redirect to root url' do
      expect(response).to redirect_to root_url
    end

    it 'returns a 302 response' do
      expect(response).to have_http_status(302)
    end
  end

  # トークンとemailが正しい場合
  context 'when both token and email are correct' do
    before do
      get edit_account_activation_path(
        user.activation_token,
        email: user.email
      )
    end

    # ログインに成功する
    it 'success login' do
      expect(is_logged_in?).to be_truthy
    end

    it 'redirect to user url' do
      expect(response).to redirect_to user
    end

    it 'returns a 302 response' do
      expect(response).to have_http_status(302)
    end
  end
end
