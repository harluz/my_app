# frozen_string_literal: true
require 'rails_helper'
RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) } 

  describe "current_user" do
    context "when session is nil" do
      before { remember(user) }
      it "Recognize the current user correctly" do
        expect(current_user).to eq user
      end
      it "success login" do
        expect(logged_in?).to be_truthy  
      end
    end

    context "when cookie is nil" do
      before { log_in(user) }
      it "Recognize the current user correctly" do
        expect(current_user).to be_truthy
      end
      it "success login" do
        expect(logged_in?).to be_truthy  
      end
    end
    

    context "when remember digest is wrong" do
      before { remember(user) }
      it "return false" do
        user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to eq nil 
      end
    end
  end
end
