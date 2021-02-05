require 'rss'
require 'tv_info'

describe TvInfo do
  let(:tv_info) { TvInfo.new }

  describe '.get_program_summaries_of_multiple_actors' do
    it 'returns program summaries given actor names' do
      rss = RSS::Parser.parse(File.read('spec/fixtures/rss.xml'), false)
      allow(RSS::Parser).to receive(:parse).and_return(rss)

      summaries = tv_info.get_program_summaries_of_multiple_actors(
        %w[有村架純 よしのちとせ]
      )
      expect(summaries.length).to eq(88)
    end
  end

  describe '.get_program_summaries' do
    it 'returns program summaries given actor name' do
      rss = RSS::Parser.parse(File.read('spec/fixtures/rss.xml'), false)
      allow(RSS::Parser).to receive(:parse).and_return(rss)

      summaries = tv_info.get_program_summaries('有村架純')
      expect(summaries.length).to eq(44)
    end
  end

  describe '.compose_url' do
    subject { tv_info.send(:compose_url, '有村架純') }

    it 'returns URL string containing actor name' do
      expected_url = 'https://www.tvkingdom.jp/rss/'\
        'schedulesBySearch.action?'\
        'condition.keyword=%E6%9C%89%E6%9D%91%E6%9E%B6%E7%B4%94&'\
        'stationPlatformId=0'
      expect(subject).to eq(expected_url)
    end
  end

  describe '.get_program_summary' do
    rss = RSS::Parser.parse(File.read('spec/fixtures/rss.xml'), false)

    subject do
      tv_info.send(:get_program_summary, '有村架純', rss.item)
    end

    it 'returns program summary' do
      expect(subject).to eq(
        {
          actor_name: '有村架純',
          title: '映画「花束みたいな恋をした」スペシャル',
          channel: 'ＴＢＳチャンネル１ 最新ドラマ・音楽・映画(Ch.616)',
          schedule: {
            start: Time.new(2021, 1, 24, 3, 0),
            end: Time.new(2021, 1, 24, 3, 30)
          }
        }
      )
    end
  end

  describe '.extract_program_title' do
    raw_title = '[映]かぞくいろ　-RAILWAYS　わたしたちの出発-[SS][字]'
    subject { tv_info.send(:extract_program_title, raw_title) }

    it 'returns program title only' do
      expect(subject).to eq('かぞくいろ　-RAILWAYS　わたしたちの出発-')
    end
  end

  describe '.extract_channel_name' do
    raw_description = '1/28 14:40～16:50 [ＷＯＷＯＷシネマ]'
    subject { tv_info.send(:extract_channel_name, raw_description) }

    it 'returns channel name' do
      expect(subject).to eq('ＷＯＷＯＷシネマ')
    end
  end

  describe '.extract_program_schedule' do
    raw_date = '2021-01-28T14:40+09:00'
    raw_description = '1/28 14:40～16:50 [ＷＯＷＯＷシネマ]'
    subject do
      tv_info.send(:extract_program_schedule, raw_date, raw_description)
    end

    it 'returns program schedule' do
      expect(subject).to eq(
        {
          start: Time.new(2021, 1, 28, 14, 40),
          end: Time.new(2021, 1, 28, 16, 50)
        }
      )
    end
  end
end
