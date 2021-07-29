require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "世田谷市場の文字列が存在することを確認" do
        expect(page).to have_content '世田谷市場'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end

    describe "ヘルプページ" do
      before do
        visit about_path
      end
  
      it "世田谷市場とは？の文字列が存在することを確認" do
        expect(page).to have_content '世田谷市場とは？'
      end
  
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('世田谷市場とは？')
      end
    end

    describe "利用規約ページ" do
      before do
        visit use_of_terms_path
      end
  
      it "利用規約の文字列が存在することを確認" do
        expect(page).to have_content '利用規約'
      end
  
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('利用規約')
      end
    end
  end
end
