require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "HomePage" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "Theme wordsの文字列が存在することを確認" do
        expect(page).to have_content 'Theme words'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end

  describe "AboutPage" do
    before do
      visit about_path
    end

    it "Theme wordsについての文字列があることを確認" do
      expect(page).to have_content 'Theme wordsについて'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('About')
    end
  end

  