module ApplicationHelper
  def full_title(page_title = '')  # full_titleメソッドを定義
    base_title = '世田谷市場'
    if page_title.blank?
      base_title  # トップページはタイトル「世田谷市場」
    else
      "#{page_title} - #{base_title}" # トップ以外のページはタイトル「利用規約 - 世田谷市場」（例）
    end
  end
end
