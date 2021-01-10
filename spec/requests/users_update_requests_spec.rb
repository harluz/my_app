# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersUpdateRequests', type: :request do
  describe 'PUT #update' do
    # ユーザーのログインの有無を確認
    describe 'before_action :logged_in_user' do
      subject { response }
      # ユーザーがログインしている場合
      context 'The user is logged in' do
        # updateへのアクセス権限を確認する（ユーザーの正当性の確認）
        describe 'before_action :correct_user' do
          let(:user) { FactoryBot.create(:user) }
          let(:other_user) { FactoryBot.create(:other_user) }
          # 正しいユーザーのとき
          before { sign_in user }
          context 'when the correct user' do
            # updateが成功するとき
            context 'when editting is successful' do
              before do
                patch user_path(user), params: { user: {
                  name: 'Foo Bar',
                  email: 'foo@bar.com',
                  password: '',
                  password_confirmation: ''
                } }
              end

              it 'redirect to user_path(user)' do
                is_expected.to redirect_to user_path(user)
              end

              it 'returns a 302 response' do
                is_expected.to have_http_status(302)
              end
            end

            # updateが失敗するとき
            context 'when editting fails' do
              before do
                patch user_path(user), params: { user: {
                  name: 'Foo Bar',
                  email: 'foo@bar',
                  password: 'foo',
                  password_confirmation: 'bar'
                } }
              end

              it 'render edit' do
                is_expected.to render_template('edit')
              end

              it 'returns a 200 response' do
                is_expected.to have_http_status(200)
              end
            end
          end

          # 正しくないユーザーのとき
          context 'when the incorrect user' do
            before { sign_in other_user }
            # 正常な値を送信しても失敗する
            context 'when editting is successful' do
              before do
                patch user_path(user), params: { user: {
                  name: 'Foo Bar',
                  email: 'foo@bar.com',
                  password: '',
                  password_confirmation: ''
                } }
              end

              it 'redirect to root url' do
                is_expected.to redirect_to root_url
              end

              it 'returns a 302 response' do
                is_expected.to have_http_status(302)
              end
            end

            # 不正な値を送信しても失敗する
            context 'when editting fails' do
              before do
                patch user_path(user), params: { user: {
                  name: 'Foo Bar',
                  email: 'foo@bar',
                  password: 'foo',
                  password_confirmation: 'bar'
                } }
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
      end
      # ユーザーがログインしていない場合
      context 'The user is not logged in' do
        let(:user) { FactoryBot.create(:user) }
        before do
          patch user_path(user)
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
