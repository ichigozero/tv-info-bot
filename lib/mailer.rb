require 'mail'

class Mailer
    def self.compose(mail_from, mail_to, actor_name, program_summaries)
        Mail.new do
            from "#{mail_from}"
            to "#{mail_to}"
            subject generate_subject(actor_name, program_summaries)
            body generate_mail_body(program_summaries)
        end
    end

    def self.generate_mail_subject(actor_name, program_summaries)
        start_date = program_summaries[0][:schedule][:start].strftime('%Y/%m/%d')
        end_date = program_summaries[-1][:schedule][:end].strftime('%Y/%m/%d')

        "#{actor_name}の出演（#{start_date} 〜 #{end_date}）"
    end

    def self.generate_mail_body(program_summaries)
        mail_body = ''

        program_summaries.each do |summary|
            mail_body += "\n\n" if mail_body.length > 0

            mail_body += "#{summary[:title]}\n"
            mail_body += "#{summary[:channel]}\n"
            mail_body += summary[:schedule][:start].strftime('%Y/%m/%d %H:%M')
            mail_body += ' 〜 '
            mail_body += summary[:schedule][:end].strftime('%H:%M')
        end

        mail_body
    end

    private_class_method :generate_mail_subject, :generate_mail_body
end