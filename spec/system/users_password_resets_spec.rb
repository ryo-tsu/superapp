require 'rails_helper'

RSpec.describe "ユーザーパスワード再設定", type: :system do
  let!(:user) { create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "newアクション" do
    before do
      visit new_password_reset_path
    end

    it "「パスワード再設定」の文字列が存在することを確認" do
      expect(page).to have_content 'パスワード再設定'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('パスワード再設定')
    end
  end

  describe "createアクション" do
    before do
      visit new_password_reset_path
    end

    context "有効なユーザーのメールアドレスを送信する" do
      before do
        fill_in :user_email, with: user.email
        click_button "送信"
      end

      it "root_pathにリダイレクトされること" do
        expect(current_path).to eq root_path
      end

      it "メール送信成功のフラッシュが表示されること" do
        expect(page).to have_content "パスワードを再設定するためのメールを送信しました"
      end

      it "正しいメールが送信されていること" do
        mail = ActionMailer::Base.deliveries.last

        aggregate_failures do
          expect(mail.to).to eq [user.email]
          expect(mail.subject).to eq "パスワードを再設定します"
        end
      end
    end

    context "無効なユーザーのメールアドレスを送信する" do
      before do
        fill_in :user_email, with: "no@example.com"
        click_button "送信"
      end

      it "newテンプレートにリダイレクトされること" do
        expect(current_path).to eq password_resets_path
      end

      it "失敗のフラッシュが表示されること" do
        expect(page).to have_content "登録されていないメールアドレスです。"
      end
    end
  end

  describe "editアクション" do
    before { user.create_reset_digest }

    context "有効なURL" do
      before do
        visit edit_password_reset_path(user.reset_token, email: user.email)
      end

      it "「パスワード再設定」の文字列が存在することを確認" do
        expect(page).to have_content 'パスワード再設定'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('パスワード再設定')
      end
    end

    context "無効なURL" do
      before do
        visit edit_password_reset_path("hogehoge", email: "no@example.com")
      end

      it "root_pathにリダイレクトされること" do
        expect(current_path).to eq root_path
      end
    end
  end

  describe "updateアクション" do
    before do
      user.create_reset_digest
      visit edit_password_reset_path(user.reset_token, email: user.email)
    end

    context "有効なパスワードとパスワード確認" do
      before do
        fill_in "パスワード", with: "foobaz"
        fill_in "パスワード(確認)", with: "foobaz"
        click_button "パスワード更新"
      end

      it "正しいフラッシュが表示される" do
        expect(page).to have_content "パスワードの再設定が完了しました。"
      end

      it "ユーザページへリダイレクトされること" do
        expect(current_path).to eq user_path(user)
      end
    end

    context "パスワードが空" do
      before do
        fill_in "パスワード", with: ""
        fill_in "パスワード(確認)", with: ""
        click_button "パスワード更新"
      end

      it "正しいフラッシュが表示される" do
        expect(page).to have_content "パスワードを入力してください"
      end

      it "editテンプレートへリダイレクトされること" do
        expect(current_path).to eq password_reset_path(user.reset_token)
      end
    end
  end
end
