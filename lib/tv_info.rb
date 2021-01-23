require 'cgi'
require 'time'

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

  def extract_channel_name(raw_description)
    raw_description.match(/\[(.+)\]/)[1]
  end

  def extract_program_schedule(raw_date, raw_description)
    end_time = raw_description.match(
      %r{[0-9]+/[0-9]+\s[0-9]+:[0-9]+～([0-9]+):([0-9]+)}
    )

    start_datetime = Time.parse(raw_date)
    end_datetime = Time.new(
      start_datetime.year,
      start_datetime.month,
      start_datetime.day,
      end_time[1].to_i,
      end_time[2].to_i
    )

    {
      start: start_datetime,
      end: end_datetime
    }
  end
end
