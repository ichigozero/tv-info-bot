require 'cgi'

class TvInfo
  private

  def compose_url(actor_name)
    escaped_name = CGI.escape(actor_name)

    'https://www.tvkingdom.jp/rss/'\
      'schedulesBySearch.action?'\
      "condition.keyword=#{escaped_name}&"\
      'stationPlatformId=0'
  end

  def extract_program_title(raw_title)
    raw_title.gsub(/\[.*?\]/, '')
  end
end
