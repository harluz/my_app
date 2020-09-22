# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    get signup_path
  end

  describe 'users#<create>' do
    it 'postデータの受け取りができること' do
      user = create(:user)
      post user_path, params: { user: id }
      expect(response).to have_http_status(302)
    end
  end
end
