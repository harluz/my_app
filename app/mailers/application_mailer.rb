# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  # 共通のアドレス
  default from: 'noreply@example.com'
  # 　viewのmailerを呼び出す
  layout 'mailer'
end
