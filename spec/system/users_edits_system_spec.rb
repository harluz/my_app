# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersEdits', type: :system do
  describe 'About edit' do
    let(:user) { FactoryBot.create(:user) }
    before do
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      click_on 'Setting'
    end
    # 編集に成功する場合
    context 'when editting is successful' do
      before do
        fill_in 'Name',	with: ''
        fill_in 'Email',	with: 'valid@invalid.com'
        fill_in 'Password',	with: 'foo'
        fill_in 'Confirmation',	with: 'foo'
        click_on 'Save changes'
      end
      # pathは正しいか
      it 'path is correct' do
        expect(current_path).to eq user_path(user)
      end

      # フラッシュメッセージは正しいか
      it 'flash message is correct' do
        expect(has_css?('.alert-danger')).to be_truthy
      end

      # 違うページにアクセスした時
      context 'when accessing another page' do
        before { visit root_url }
        # フラッシュメッセージが消える
        it 'is flash dissapear' do
          expect(page).to_not have_selector('.alert-success', text: 'Profile updated')
        end
      end

      # ページをリロードした時
      context 'when the page is reloaaded' do
        before { visit current_path }
        # フラッシュメッセージが消える
        it 'is flash diasspear' do
          expect(page).to_not have_selector('.alert-success', text: 'Profile updated')
        end
      end
    end

    # 編集に失敗する場合
    context 'when editting fails' do
      before do
        fill_in 'Name',	with: ''
        fill_in 'Email',	with: 'invalid@invalid'
        fill_in 'Password',	with: 'foo'
        fill_in 'Confirmation',	with: 'bar'
        click_on 'Save changes'
      end
      # pathは正しいか
      it 'path is correct' do
        expect(current_path).to eq user_path(user)
      end

      # フラッシュメッセージは正しいか
      it 'flash message is correct' do
        expect(has_css?('.alert-danger')).to be_truthy
      end

      # 違うページにアクセスした時
      context 'when accessing another page' do
        before { visit root_url }
        # フラッシュメッセージが消える
        it 'is flash dissapear' do
          expect(has_css?('.alert-danger')).to_not be_truthy
        end
      end

      # ページをリロードした時
      context 'when the page is reloaaded' do
        before { visit current_path }
        # フラッシュメッセージが消える
        it 'is flash diasspear' do
          expect(has_css?('.alert-danger')).to_not be_truthy
        end
      end
    end
  end
end
