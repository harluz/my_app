# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToSessions', type: :request do
  describe 'GET #new' do
    before { get login_path }
    subject { response }

    it 'responds successfully' do
      is_expected.to be_successful
    end

    it 'return a 200 resnponse' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'POST #create' do
    #   有効な値を入力した時
    describe 'valid request' do
      describe 'check response' do
        before do
          @user = create(:user)
          post login_path, params: { session: { email: @user.email,
                                                password: @user.password } }
        end

        it 'redirect to show' do
          expect(response).to redirect_to user_path(User.last)
        end

        it 'return a 302 response' do
          expect(response).to have_http_status(302)
        end

        it 'log in successfully' do
          expect(is_logged_in?).to be_truthy
        end
      end
    end

    # 無効な値を入力した時
    describe 'invalid request' do
      describe 'check response' do
        before do
          post login_path, params: { session: { email: '',
                                                password: '' } }
        end

        it 'render new' do
          expect(response).to render_template('new')
        end

        it 'responds successfully' do
          expect(response).to be_successful
        end

        it 'returns a 200 response' do
          expect(response).to have_http_status(200)
        end

        it 'log in unsuccessfully' do
          expect(is_logged_in?).to be_falsy
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'check response' do
      before do
        @user = create(:user)
        post login_path, params: { session: { email: @user.email,
                                              password: @user.password } }
        delete logout_path
      end

      it 'redirect to root' do
        expect(response).to redirect_to root_url
      end

      it 'return a 302 response' do
        expect(response).to have_http_status(302)
      end

      it 'log out successfully' do
        expect(is_logged_in?).to be_falsy
      end
    end
  end
end
