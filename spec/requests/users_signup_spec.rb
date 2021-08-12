require 'rails_helper'

RSpec.describe "ユーザー登録", type: :request do
  include ActiveJob::TestHelper
  before do
    ActionMailer::Base.deliveries.clear
    get signup_path
  end

  it "正常なレスポンスを返すこと" do
    expect(response).to be_success
    expect(response).to have_http_status "200"
  end

  it "有効なユーザーで登録" do
    perform_enqueued_jobs do
      expect {
        post users_path, params: { user: { name: "Example User",
                                           email: "user@example.com",
                                           password: "password",
                                           password_confirmation: "password" } }
      }.to change(User, :count).by(1)
      expect(ActionMailer::Base.deliveries.size).to eq 1
      user = assigns(:user)
      expect(user.activated?).to be_falsey
      # 有効化していない状態でログインしてみる
      login_for_request(user)
      expect(is_logged_in?).to be_falsey
      # 有効化トークンが不正な場合
      get edit_account_activation_path("invalid token", email: user.email)
      expect(is_logged_in?).to be_falsey
      # トークンは正しいがメールアドレスが無効な場合
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      expect(is_logged_in?).to be_falsey
      # 有効化トークンが正しい場合
      get edit_account_activation_path(user.activation_token, email: user.email)
      expect(user.reload.activated?).to be_truthy
      follow_redirect!
      redirect_to @user
      expect(response).to render_template('users/show')
      expect(is_logged_in?).to be_truthy
    end
  end

  it "無効なユーザーで登録" do
    perform_enqueued_jobs do
      expect {
        post users_path, params: { user: { name: "",
                                           email: "user@example.com",
                                           password: "password",
                                           password_confirmation: "pass" } }
      }.not_to change(User, :count)
        expect(is_logged_in?).not_to be_truthy
    end
  end
end
