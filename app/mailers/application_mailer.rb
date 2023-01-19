class ApplicationMailer < ActionMailer::Base
  default from: ENV['SUNRYSE_EMAIL']
  layout 'mailer'
  helper ApplicationHelper
  helper CloudinaryHelper
  helper DeviseHelper
  helper NotificationHelper
  helper OrderHelper
  helper PaymentIntentHelper
  helper UserHelper
end
