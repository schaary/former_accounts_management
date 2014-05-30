# encoding: utf-8

class NotifyFormerEmployee < ActionMailer::Base
  default from: Rails.application.secrets.from_address

  def notify
    mail to: 'michael.schaarschmidt@itz.uni-halle.de', subject: 'test'
  end
end
