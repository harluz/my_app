require 'rails_helper'

RSpec.describe "UsersDestroySystems", type: :system do
  describe "About the behaviro of destroy" do
    #　管理者による削除が成功する時
    context "When the administrator deletes successfully" do
      let!(:admin_user) { FactoryBot.create(:user, :admin) }
      let!(:other_user) { FactoryBot.create(:other_user) }
      before do
        sign_in admin_user
        visit users_path
        click_on 'delete'
      end
      #　pathは正しいか
      it 'path is correct' do
        expect(current_path).to eq users_path
      end
      #　フラッシュメッセージは正しいか
      it 'flash message is correct' do
        expect(page).to have_selector('.alert-success', text: 'User deleted')
      end

      #　違うページにアクセスした時
      context "when accessing another page" do
        before { visit root_url }
        # フラッシュメッセージが消える
        it 'is flash dissapear' do
          expect(page).to_not have_selector('.alert-success', text: 'User deleted')
        end
      end
      
      #　ページをリロードした時
      context "when the page is reloaded" do
        before { visit current_path }
        # フラッシュメッセージが消える
        it 'is flash dissapear' do
          expect(page).to_not have_selector('.alert-success', text: 'User delete')
        end
      end
      
    end
    
    #　一般ユーザーのとき
    context "when the user is a general user" do
      let!(:other_user) { FactoryBot.create(:other_user) }
      before do
        sign_in other_user
        visit users_path
      end
      #　deleteリンクは表示されない
      it 'Delete link is not displayed' do
        expect(page).to_not  have_link 'delete'
      end
    end
    
  end
  
end
