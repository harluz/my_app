# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SessionsSystems', type: :system do
  before do
    visit login_path
  end

  # 有効な値を入力
  describe 'enter a valid values' do
    before do
      @user = create(:user)
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end

    subject { page }
    # ログインした時のページレイアウトの確認
    describe 'log in' do
      it 'check the current path' do
        is_expected.to have_current_path user_path(@user)
      end

      it 'is login_path dissapear' do
        is_expected.to_not have_link nil, href: login_path
      end

      describe 'check dropdown menu' do
        before { click_link 'Account' }
        it 'is profile link appear' do
          is_expected.to have_link 'Profile', href: user_path(@user)
        end

        it 'is logout link appear' do
          # is_expected.to have_link 'Log out', href: logout_path
          is_expected.to have_button 'Log out'
        end
      end
    end

    describe 'log out' do
      before do
        click_link 'Account'
        click_button 'Log out'
      end

      it 'check the current path' do
        is_expected.to have_current_path root_url
      end

      it 'is login link appear' do
        is_expected.to have_link 'Log in', href: login_path
      end

      it 'is account link disappear' do
        is_expected.to_not have_link 'Account'
      end

      it 'is profile link disappear' do
        is_expected.to_not have_link nil, href: user_path(@user)
      end

      it 'is logout_path dissapear' do
        is_expected.to_not have_link nil, href: logout_path
      end
    end
  end

  # 無効な値を入力
  describe 'enter an invalid values' do
    before do
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      click_button 'Log in'
    end

    # エラーメッセージが表示される
    it 'gets a flash messages' do
      expect(page).to have_selector('.alert-danger', text: 'Invalid email / password combination')
    end

    # renderの確認
    it 'render to /login url' do
      expect(current_path).to eq login_path
    end

    # 違うページにアクセスした時
    describe 'access to other page' do
      before { visit root_url }

      # フラッシュメッセージが消える
      it 'is flash disappear' do
        expect(page).to_not have_selector('.alert-danger', text: 'Invalid email / password combination')
      end
    end

    # ページを更新した時
    describe 'reload page' do
      before { visit current_path }
      # フラッシュメッセージが消える
      it 'is flash dissapear' do
        expect(page).to_not have_selector('.alert-danger', text: 'Invalid email / password combination')
      end
    end
  end
end
