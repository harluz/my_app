# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersCreateRequests', type: :request do
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

        it 'send a email' do
          expect(ActionMailer::Base.deliveries.size).to eq(1)
        end

        it 'redirect to root' do
          is_expected.to redirect_to root_url
          # is_expected.to redirect_to user_path(User.last)
        end

        it 'returns a 302 response' do
          is_expected.to have_http_status(302)
        end

        it 'log in successfully' do
          expect(is_logged_in?).to be_falsy
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

        it 'not send a email' do
          expect(ActionMailer::Base.deliveries.size).to eq(0)
        end

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
end
