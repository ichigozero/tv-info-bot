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
end
