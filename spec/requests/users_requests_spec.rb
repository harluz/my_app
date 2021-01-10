# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersRequests', type: :request do
  describe 'GET #index' do
    subject { response }
    # ユーザーのログインの有無を確認
    describe 'before_action :logged_in_user' do
      let!(:user) { FactoryBot.create(:user) }
      # ユーザーがログインしている場合
      context 'The user is logged in' do
        before do
          sign_in(user)
          get users_path
        end
        it 'responds successfully' do
          is_expected.to be_successful
        end

        it 'returns a 200 response' do
          is_expected.to have_http_status(200)
        end
      end
      # ユーザーがログインしていない場合
      context 'The user is not logged in' do
        before do
          get users_path
        end

        it 'redirect to login url' do
          is_expected.to redirect_to login_url
        end

        it 'returns a 302 response' do
          is_expected.to have_http_status(302)
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryBot.create(:user) }
    let(:show_nil_user) { FactoryBot.build(:show_nil_user) }
    subject { response }

    # そのユーザーが存在する場合
    context 'when that user exists' do
      before { get user_path user }

      it 'responds successfully' do
        is_expected.to be_successful
      end

      it 'returns a 200 response' do
        is_expected.to have_http_status(200)
      end
    end

    # そのユーザーが存在しない場合
    context 'when that user does not exist' do
      before { get user_path show_nil_user }
      it 'redirect to show' do
        is_expected.to redirect_to users_path
      end

      it 'returns a 302 response' do
        is_expected.to have_http_status(302)
      end
    end
  end

  describe 'GET #new' do
    before { get new_user_path }
    subject { response }

    it 'responds successfully' do
      is_expected.to be_successful
    end

    it 'returns a 200 response' do
      is_expected.to have_http_status(200)
    end
  end
end
