# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersRequests', type: :request do
  before do
    get signup_path
  end

  describe 'users#<create>' do
    it 'postデータの受け取りができること' do
      # user = create(:user)
      post users_path, params: { user: FactoryBot.attributes_for(:user) }
      expect(response).to have_http_status(302)
    end
  end
end
