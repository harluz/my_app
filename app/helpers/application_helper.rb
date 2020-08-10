# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title = '')  # full_titleメソッドを定義
    base_title = 'Theme words'
    if page_title.blank?
      base_title  # トップページはタイトル「Theme words」
    else
      "#{page_title} - #{base_title}" # トップ以外のページはタイトル「profile - Theme words」（例）
    end
  end
end