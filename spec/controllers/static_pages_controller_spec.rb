# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    it 'returns http success' do
      get :home
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #about' do
    it 'returns http success' do
      get :about
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #my_list' do
    it 'returns http success' do
      get :my_list
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #suggest' do
    it 'returns http success' do
      get :suggest
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #seek' do
    it 'returns http success' do
      get :seek
      expect(response).to have_http_status(200)
    end
  end
end
