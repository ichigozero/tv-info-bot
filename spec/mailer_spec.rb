require 'mailer'
require 'time'

describe Mailer do
  let(:actor_name) { 'John Doe' }
  let(:program_summaries) do
    [
      {
        title: 'Title1',
        channel: 'Channel1',
        schedule: {
          start: Time.new(2021, 1, 1, 10, 30),
          end: Time.new(2021, 1, 1, 11, 0)
        }
      },
      {
        title: 'Title2',
        channel: 'Channel2',
        schedule: {
          start: Time.new(2021, 1, 2, 16, 30),
          end: Time.new(2021, 1, 2, 17, 0)
        }
      }
    ]
  end

  describe '.generate_mail_subject' do
    subject do
      Mailer.send(:generate_mail_subject, actor_name, program_summaries)
    end

    it 'returns mail subject' do
      expect(subject).to eq('John Doeの出演（2021/01/01 〜 2021/01/02）')
    end
  end

  describe '.generate_mail_body' do
    subject do
      Mailer.send(:generate_mail_body, program_summaries)
    end

    it 'returns mail subject' do
      mail_body = "Title1\nChannel1\n2021/01/01 10:30 〜 11:00\n\n"
      mail_body += "Title2\nChannel2\n2021/01/02 16:30 〜 17:00"
      expect(subject).to eq(mail_body)
    end
  end
end
