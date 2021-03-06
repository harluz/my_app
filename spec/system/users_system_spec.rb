# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'Signupページに遷移できるか' do
    it 'Sign upが表示されるか' do
      visit root_path
      click_on 'Sign up now'
      expect(page).to have_content('Sign up')
    end
  end

  describe 'user create a new account' do
    # 有効な値が入力された時
    context 'when the user enters a valid value' do
      before do
        user = build(:user)
        visit new_user_path
        fill_in 'Name', with: user.name
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Confirmation', with: user.password_confirmation
        click_button 'Create my account'
      end
      # フラッシュメッセージが表示される
      it 'gets a flash message' do
        expect(page).to have_selector('.alert-info', text: 'Please check your email to activate your account.')
      end

      # 違うページにアクセスした時
      context 'when accessing another page' do
        before { visit root_url }
        # フラッシュメッセージが消える
        it 'is flash dissapear' do
          expect(page).to_not have_selector('.alert-info', text: 'Please check your email to activate your account.')
        end
      end
      # ページをリロードした時
      context 'when the page is reloaaded' do
        before { visit current_path }
        # フラッシュメッセージが消える
        it 'is flash dissapear' do
          expect(page).to_not have_selector('.alert-success', text: 'Welcome to the Theme Words')
        end
      end
    end

    # 無効な値が入力された時
    context 'when the user enters an invalid value' do
      before do
        visit new_user_path
        fill_in 'Name', with: ' '
        fill_in 'Email', with: ' '
        fill_in 'Password', with: ' '
        fill_in 'Confirmation', with: ' '
        click_button 'Create my account'
      end

      # subject { page }
      # エラーメッセージが表示される
      it 'gets an error message' do
        # is_expected.to have_selector('#error_explanation')
        # is_expected.to have_selector('.alert-danger', text: 'The form contains 6 errors.')
        expect(page).to have_content("can't be blank")
      end

      # renderの確認
      it 'render to /signup url' do
        expect(current_path).to eq users_path
      end

      # 違うページにアクセスした時
      context 'when accessing another page' do
        before { visit root_url }
        # フラッシュメッセージが消える
        it 'is flash dissapear' do
          expect(page).to_not have_selector('.alert-danger', text: 'The form contains 6 errors.')
        end
      end
      # ページをリロードした時
      context 'when the page is reloaaded' do
        before { visit current_path }
        # フラッシュメッセージが消える
        it 'is flash diasspear' do
          expect(page).to_not have_selector('.alert-danger', text: 'The form contains 6 errors.')
        end
      end
    end
  end
end
