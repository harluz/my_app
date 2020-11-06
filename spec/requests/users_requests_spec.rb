# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersRequests', type: :request do
  before do
    get signup_path
  end

  describe 'GET #index'

  describe 'GET #show' do
    before { get users_path, params: { user: create(:user) } }
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
    describe 'valid request' do
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

        it 'rediorect to show' do
          is_expected.to redirect_to user_path(User.last)
        end

        it 'returns a 302 response' do
          is_expected.to have_http_status(302)
        end
      end
    end

    describe 'invalid request' do
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
        end
      end
    end
  end

  describe 'GET #edit' do end

  describe 'PUT #update' do end

  describe 'DELETE #destroy' do end

end
