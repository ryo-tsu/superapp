class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      # sessionをつなぐ。application_controllerにsessions_helperをincludeしている
      remember user
      # cookieにidとトークンを保存する
      redirect_to user
    else
      flash.now[:danger] = 'メールアドレスとパスワードの組み合わせが違います'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
