# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PasswordResetUpdateRequests', type: :request do
  describe 'PUT #update' do
    let(:user) { FactoryBot.create(:user) }
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
    end
    subject { response }

    # 無効なパスワード
    context 'when user sends wrong password' do
      before do
        user = controller.instance_variable_get('@user')
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: 'foobaz',
                  password_confirmation: 'hogehoge'
                }
              }
      end

      it 'render edit' do
        is_expected.to render_template('edit')
      end

      it 'returns a 200 response' do
        is_expected.to have_http_status(200)
      end
    end

    # 空のパスワード
    context 'when user sends blank password' do
      before do
        user = controller.instance_variable_get('@user')
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: '',
                  password_confirmation: ''
                }
              }
      end

      it 'render edit' do
        is_expected.to render_template('edit')
      end

      it 'returns a 200 response' do
        is_expected.to have_http_status(200)
      end
    end

    # 有効なパスワード
    context 'when user sends correct password' do
      before do
        user = controller.instance_variable_get('@user')
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: 'password',
                  password_confirmation: 'password'
                }
              }
      end

      it 'the user is logged in' do
        expect(is_logged_in?).to be_truthy
      end

      it 'reset_digest is nil' do
        expect(user.reload.reset_digest).to eq nil
      end

      it 'redirect to user' do
        is_expected.to redirect_to user
      end

      it 'returns a 302 response' do
        is_expected.to have_http_status(302)
      end
    end
  end
end
