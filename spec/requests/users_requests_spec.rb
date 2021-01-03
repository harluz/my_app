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
    before { get user_path user }
    subject { response }

    it 'responds successfully' do
      is_expected.to be_successful
    end

    it 'returns a 200 response' do
      is_expected.to have_http_status(200)
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

  describe 'POST #create' do
    context 'valid request' do
      describe 'check users count' do
        it 'add a user' do
          expect do
            post signup_path, params: { user: attributes_for(:user) }
          end.to change(User, :count).by(1)
        end
      end

      describe 'check　response' do
        before { post users_path, params: { user: attributes_for(:user) } }
        subject { response }

        it 'redirect to show' do
          is_expected.to redirect_to user_path(User.last)
        end

        it 'returns a 302 response' do
          is_expected.to have_http_status(302)
        end

        it 'log in successfully' do
          expect(is_logged_in?).to be_truthy
        end
      end
    end

    context 'invalid request' do
      describe 'check user count' do
        it 'does not add a user' do
          expect do
            post signup_path, params: { user: attributes_for(:invalid_user) }
          end.to change(User, :count).by(0)
        end
      end

      describe 'check response' do
        before { post signup_path, params: { user: attributes_for(:invalid_user) } }
        subject { response }

        it 'render new' do
          is_expected.to render_template('new')
        end

        it 'responds successfully' do
          is_expected.to be_successful
        end

        it 'returns a 200 response' do
          is_expected.to have_http_status(200)
        end

        it 'log in unsuccessfully' do
          expect(is_logged_in?).to be_falsy
        end
      end
    end
  end

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
          context "when the correct user" do
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
          context "when the incorrect user" do
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
    describe "User count verification" do
      let!(:user) { FactoryBot.create(:user, :admin) }
      let!(:other_user) { FactoryBot.create(:other_user) }
      before { sign_in user }
      # deleteが成功するとき
      context "When delete succeeds" do
        it 'User count dectrases' do
          expect do
            delete user_path(other_user), params: { id: other_user.id }
          end.to change(User, :count).by(-1)
        end
      end
      
      # deleteが失敗するとき
      context "When delete fails" do
        it 'User count does not change' do
          expect do
            delete user_path(user), params: { id: user.id }
          end.to change(User, :count).by(0)
        end
      end
    end
  end
end
