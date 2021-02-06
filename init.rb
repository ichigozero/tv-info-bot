#!/usr/bin/env ruby

require 'mail'

require './lib/mailer'
require './lib/tv_info'

actor_name = ARGV[0]
mail_to = ARGV[1]

tv_info = TvInfo.new
summaries = tv_info.get_program_summaries(actor_name)

Mail.defaults do
    delivery_method :smtp, {
        :address => ENV.fetch('SMTP_ADDRESS'),
        :port => ENV.fetch('SMTP_PORT'),
        :user_name => ENV.fetch('MAIL_ADDRESS'),
        :password => ENV.fetch('MAIL_PASSWORD'),
        :authentication => :login,
        :ssl => true,
    }
end

mail = Mailer.compose(
    ENV.fetch('MAIL_ADDRESS'),
    mail_to,
    actor_name,
    summaries
)

mail.charset = 'UTF-8'
mail.content_transfer_encoding = "8bit"
mail.deliver
