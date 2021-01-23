require 'tv_info'

describe TvInfo do
  before(:each) { @tv_info = TvInfo.new }

  describe '.compose_url' do
    subject { @tv_info.send(:compose_url, '有村架純') }

    it 'returns URL string containing actor name' do
      expected_url = 'https://www.tvkingdom.jp/rss/'\
        'schedulesBySearch.action?'\
        'condition.keyword=%E6%9C%89%E6%9D%91%E6%9E%B6%E7%B4%94&'\
        'stationPlatformId=0'
      expect(subject).to eq(expected_url)
    end
  end

  describe '.extract_program_title' do
    raw_title = '[映]かぞくいろ　-RAILWAYS　わたしたちの出発-[SS][字]'
    subject { @tv_info.send(:extract_program_title, raw_title) }

    it 'returns program title only' do
      expect(subject).to eq('かぞくいろ　-RAILWAYS　わたしたちの出発-')
    end
  end

  describe '.extract_channel_name' do
    raw_description = '1/28 14:40～16:50 [ＷＯＷＯＷシネマ]'
    subject { @tv_info.send(:extract_channel_name, raw_description) }

    it 'returns channel name' do
      expect(subject).to eq('ＷＯＷＯＷシネマ')
    end
  end

  describe '.extract_program_schedule' do
    raw_date = '2021-01-28T14:40+09:00'
    raw_description = '1/28 14:40～16:50 [ＷＯＷＯＷシネマ]'
    subject do
      @tv_info.send(:extract_program_schedule, raw_date, raw_description)
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
