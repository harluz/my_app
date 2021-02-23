# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PostsRequests', type: :request do
  # ユーザーがログインしていないとき
  describe 'should redirect create when not logged in' do
    let(:user_post) { FactoryBot.attributes_for(:post) }
    let(:post_request) { post posts_path, params: { post: user_post } }
    subject { post_request }
    it 'check post count' do
      expect { subject }.to change(Post, :count).by(0)
    end

    it 'redirect to login_url' do
      is_expected.to redirect_to login_url
    end
  end

  # ユーザーがログインしていないとき
  describe 'should redirect destroy when not logged in' do
    let!(:user_post) { FactoryBot.create(:post) }
    let(:delete_request) { delete post_path(user_post) }
    subject { delete_request }
    it 'check post count' do
      expect { subject }.to change(Post, :count).by(0)
    end

    it 'redirect to login_url' do
      is_expected.to redirect_to login_url
    end
  end
end
