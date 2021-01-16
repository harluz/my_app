# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PasswordResetsRequests', type: :request do
  describe 'GET #new' do
    before { get new_password_reset_path }
    subject { response }

    it 'responds successfully' do
      is_expected.to be_successful
    end

    it 'returns a 200 response' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'POST create' do
    subject { response }
    let(:user) { FactoryBot.create(:user) }

    # メールアドレスが有効な場合
    context 'when the email address is valid' do
      before do
        post password_resets_path, params: { password_reset: {
          email: user.email
        } }
      end

      it 'sent a mail' do
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it 'redirect to root url' do
        is_expected.to redirect_to root_url
      end

      it 'returns a 302 response' do
        is_expected.to have_http_status(302)
      end
    end

    # メールアドレスが無効な場合
    context 'when the email address is invalid' do
      before do
        post password_resets_path, params: { password_reset: {
          email: ''
        } }
      end

      it 'render new' do
        is_expected.to render_template('new')
      end

      it 'returns a 200 response' do
        is_expected.to have_http_status(200)
      end
    end
  end

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
    context "when user sends correct password" do
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
        expect(is_logged_in?).to  be_truthy
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

  describe 'before_action get_user' do
  end

  describe 'before_action valid_user' do
  end

  describe 'before_action check_expiration' do
    let(:user) { FactoryBot.create(:user) }
    subject { response }
    context "when user updates after 3 hours" do
      before do
        post password_resets_path, params: { password_reset: { email: user.email } }
        user = controller.instance_variable_get('@user')
        user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(user.reset_token),
              params: {
                email: user.email,
                user: {
                  password: 'password',
                  password_confirmation: 'password'
                }
              }
      end

      it 'redirect to new_password_reset' do
        is_expected.to redirect_to new_password_reset_url
      end
  
      it 'returns a 302 response' do
        is_expected.to have_http_status(302)
      end
    end
  end
end
