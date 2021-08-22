require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  describe "アカウント有効化メール" do
    let(:mail) { UserMailer.account_activation(user) }
    let(:mail_body_html) { mail.html_part.body.encoded }
    let(:mail_body_text) { mail.text_part.body.encoded }

    it "ユーザーあてにメールを送信すること" do
      expect(mail.to).to eq([user.email])
    end

    it "正しい送信元からメールを送信すること" do
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "正しい件名のメールを送信すること" do
      expect(mail.subject).to eq("世田谷市場のアカウントを有効にします")
    end

    it "ユーザの名前が正しく表示されること" do
      expect(mail_body_html).to match(user.name)
      expect(mail_body_text).to match(user.name)
    end

    it "アクティベーショントークンが含まれること" do
      expect(mail_body_html).to match(user.activation_token)
      expect(mail_body_text).to match(user.activation_token)
    end

    it "ユーザーのメールアドレスが含まれること" do
      expect(mail_body_html).to match CGI.escape(user.email)
      expect(mail_body_text).to match CGI.escape(user.email)
    end
  end

  describe "パスワード再設定" do
    before do
      user.create_reset_digest
    end

    let(:mail) { UserMailer.password_reset(user) }
    let(:mail_body_html) { mail.html_part.body.encoded }
    let(:mail_body_text) { mail.text_part.body.encoded }

    it "ユーザーあてにメールを送信すること" do
      expect(mail.to).to eq([user.email])
    end

    it "正しい送信元からメールを送信すること" do
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "正しい件名のメールを送信すること" do
      expect(mail.subject).to eq("パスワードを再設定します")
    end

    it "パスワードリセットトークンが含まれること" do
      expect(mail_body_html).to match(user.reset_token)
      expect(mail_body_text).to match(user.reset_token)
    end

    it "ユーザーのメールアドレスが含まれること" do
      expect(mail_body_html).to match CGI.escape(user.email)
      expect(mail_body_text).to match CGI.escape(user.email)
    end
  end
end
