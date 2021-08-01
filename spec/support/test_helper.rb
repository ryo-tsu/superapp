include ApplicationHelper # full_titleメソッドの読み込み

def is_logged_in?
  !session[:user_id].nil?
  # sessionにuser_idがnilでなければtrue→sessionに何かしら入っていればログインしてますよ
end