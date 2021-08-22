require 'rails_helper'

RSpec.describe "パスワード再設定", type: :request do
  include ActiveJob::TestHelper
  let!(:user) { create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
    user.create_reset_digest
  end

  describe "newアクション" do
    it "正常なレスポンスを返すこと" do
      get new_password_reset_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end

  describe "createアクション" do
    it 'メールアドレスが有効' do
      post password_resets_path, params: { password_reset: { email: user.email } }
      aggregate_failures do
        expect(user.reset_digest).not_to eq user.reload.reset_digest
        expect(ActionMailer::Base.deliveries.size).to eq 1
        expect(response).to redirect_to root_url
      end
    end

    it 'メールアドレスが無効' do
      post password_resets_path, params: { password_reset: { email: "" } }
      aggregate_failures do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "editアクション" do
    it "無効なメールアドレス" do
      get edit_password_reset_path(user.reset_token, email: "")
      expect(response).to redirect_to root_url
    end

    it "無効なユーザー" do
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to redirect_to root_url
    end

    it "メールアドレスが有効で、トークンが無効" do
      get edit_password_reset_path("wrong", email: user.email)
      expect(response).to redirect_to root_url
    end

    it 'メールアドレスもトークンも有効' do
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to have_http_status(200)
    end
  end

  describe "updateアクション" do
    it "無効なパスワードとパスワード確認" do
      patch password_reset_path(user.reset_token),
            params: {
              email: user.email,
              user: {
                password: "foobaz",
                password_confirmation: "barquux",
              },
            }
      expect(response).to have_http_status(200)
    end

    it "パスワードが空" do
      patch password_reset_path(user.reset_token),
            params: {
              email: user.email,
              user: {
                password: "",
                password_confirmation: "",
              },
            }
      expect(response).to have_http_status(200)
    end

    it "有効なパスワードとパスワード確認" do
      patch password_reset_path(user.reset_token),
            params: {
              email: user.email,
              user: {
                password: "foobaz",
                password_confirmation: "foobaz",
              },
            }
      aggregate_failures do
        expect(is_logged_in?).to be_truthy
        expect(user.reload.reset_digest).to eq nil
        expect(response).to redirect_to user
      end
    end
  end
end
