# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PasswordResetEditRequests', type: :request do
  describe 'GET #edit' do
    let(:user) { FactoryBot.create(:user) }
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
    end
    subject { response }
    # メールアドレスが無効
    context 'when user sends correct token and wrong email' do
      before do
        user = controller.instance_variable_get('@user')
        get edit_password_reset_path(user.reset_token, email: '')
      end

      it 'redirect to root url' do
        is_expected.to redirect_to root_url
      end

      it 'returns a 302 response' do
        is_expected.to have_http_status(302)
      end
    end

    # ユーザーが無効
    context 'when not activated user sends correct token and email' do
      before do
        user = controller.instance_variable_get('@user')
        user.toggle!(:activated)
        get edit_password_reset_path(user.reset_token, email: user.email)
      end

      it 'redirect to root url' do
        is_expected.to redirect_to root_url
      end

      it 'returns a 302 response' do
        is_expected.to have_http_status(302)
      end
    end

    # トークンが無効
    context 'when user sends wrong token and correct email' do
      before { get edit_password_reset_path('wrong', email: user.email) }

      it 'redirect to root url' do
        is_expected.to redirect_to root_url
      end

      it 'returns a 302 response' do
        is_expected.to have_http_status(302)
      end
    end

    # メールアドレスとトークンが有効
    context 'when user sends correct token and email' do
      before do
        user = controller.instance_variable_get('@user')
        get edit_password_reset_path(user.reset_token, email: user.email)
      end

      it 'returns a 200 response' do
        is_expected.to have_http_status(200)
      end
    end
  end
end
