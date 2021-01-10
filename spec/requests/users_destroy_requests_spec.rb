# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersDestroyRequests', type: :request do
  describe 'DELETE #destroy' do
    # ユーザーのログインの有無を確認
    describe 'before_action :logged_in_user' do
      subject { response }
      let!(:user) { FactoryBot.create(:user, :admin) }
      let!(:other_user) { FactoryBot.create(:other_user) }
      # ユーザーがログインしている場合
      context 'The user is logged in' do
        before do
          sign_in(user)
          delete user_path(other_user)
        end
        it 'responds successfully' do
          is_expected.to redirect_to users_url
        end

        it 'returns a 200 response' do
          is_expected.to have_http_status(302)
        end
      end
      # ユーザーがログインしていない場合
      context 'The user is not logged in' do
        before { delete user_path(user) }

        it 'redirect to login url' do
          is_expected.to redirect_to login_url
        end

        it 'returns a 302 response' do
          is_expected.to have_http_status(302)
        end
      end
    end

    # adminであるかを確認
    describe 'before_action :admin_user' do
      let!(:user) { FactoryBot.create(:user, :admin) }
      let!(:other_user) { FactoryBot.create(:other_user) }
      let!(:other_user2) { FactoryBot.create(:other_user) }
      subject { response }
      # アドミンである場合
      context 'The user is admin' do
        before do
          sign_in(user)
          delete user_path(other_user)
        end
        it 'responds successfully' do
          is_expected.to redirect_to users_url
        end

        it 'returns a 200 response' do
          is_expected.to have_http_status(302)
        end
      end

      # アドミンでない場合
      context 'The user is not admin' do
        before do
          sign_in(other_user)
          delete user_path(other_user2)
        end
        it 'redirect to root url' do
          is_expected.to redirect_to root_url
        end

        it 'returns a 302 response' do
          is_expected.to have_http_status(302)
        end
      end
    end

    # ユーザー数の検証
    describe 'User count verification' do
      let!(:user) { FactoryBot.create(:user, :admin) }
      let!(:other_user) { FactoryBot.create(:other_user) }
      before { sign_in user }
      # deleteが成功するとき
      context 'When delete succeeds' do
        it 'User count dectrases' do
          expect do
            delete user_path(other_user), params: { id: other_user.id }
          end.to change(User, :count).by(-1)
        end
      end

      # deleteが失敗するとき
      context 'When delete fails' do
        it 'User count does not change' do
          expect do
            delete user_path(user), params: { id: user.id }
          end.to change(User, :count).by(0)
        end
      end
    end
  end
end
