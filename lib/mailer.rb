require 'mail'

class Mailer
  def self.compose(mail_from, mail_to, actor_name, program_summaries)
    mail_subject = generate_mail_subject(actor_name, program_summaries)
    mail_body = generate_mail_body(program_summaries)

    puts 'Composing mail'

    Mail.new do
      from mail_from
      to mail_to
      subject mail_subject
      body mail_body
    end
  end

  def self.generate_mail_subject(actor_name, program_summaries)
    puts 'Generating mail subject'

    start_date = program_summaries[0][:schedule][:start].strftime('%Y/%m/%d')
    end_date = program_summaries[-1][:schedule][:end].strftime('%Y/%m/%d')

    "#{actor_name}の出演（#{start_date} 〜 #{end_date}）"
  end

  def self.generate_mail_body(program_summaries)
    puts 'Generating mail body'

    mail_body = ''

    program_summaries.each do |summary|
      mail_body += "\n\n" if mail_body.length.positive?

      mail_body += summary[:schedule][:start].strftime('%Y/%m/%d %H:%M')
      mail_body += ' 〜 '
      mail_body += summary[:schedule][:end].strftime('%H:%M')
      mail_body += "\n#{summary[:title]}"
      mail_body += "\n#{summary[:channel]}"
    end

    mail_body
  end

  private_class_method :generate_mail_subject, :generate_mail_body
end
