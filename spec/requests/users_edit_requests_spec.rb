# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersEditRequests', type: :request do
  describe 'GET #edit' do
    subject { response }
    # ユーザーのログインの有無を確認
    describe 'before_action :logged_in_user' do
      # ユーザーがログインしている場合
      context 'The user is logged in' do
        # editへのアクセス権限を確認する（ユーザーの正当性の確認）
        describe 'before_action :correct_user' do
          let!(:user) { FactoryBot.create(:user) }
          let!(:other_user) { FactoryBot.create(:other_user) }
          # 正しいユーザーの時
          context 'When the corret user' do
            before do
              sign_in(user)
              get edit_user_path(user)
            end

            it 'responds successfully' do
              is_expected.to be_successful
            end

            it 'returns a 200 response' do
              is_expected.to have_http_status(200)
            end
          end
          # 正しくないユーザーの時
          context 'When the incorrect user' do
            before do
              sign_in(other_user)
              get edit_user_path(user)
            end

            it 'redirect to root url' do
              is_expected.to redirect_to root_url
            end

            it 'returns a 302 response' do
              is_expected.to have_http_status(302)
            end
          end
        end
      end

      # ユーザーがログインしていない場合
      context 'The user is not logged in' do
        let(:user) { FactoryBot.create(:user) }
        before do
          get edit_user_path(user)
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
end
