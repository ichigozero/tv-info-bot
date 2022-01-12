require 'cgi'
require 'rss'
require 'time'

class TvInfo
  def get_program_summaries_of_multiple_actors(actor_names)
    summaries = {}

    actor_names.each do |actor_name|
      summaries[actor_name] = get_program_summaries(actor_name)
    end

    summaries
  end

  def get_program_summaries(actor_name, channel_to_filters = nil)
    url = compose_url(actor_name)
    puts "Fetching data of #{url}"
    summaries = []

    begin
      rss = RSS::Parser.parse(url)
      rss.items.each do |rss_item|
        summary = get_program_summary(rss_item, channel_to_filters)
        summaries << summary unless summary.nil?
      end
    rescue RSS::MissingTagError
      puts 'No data to fetch'
    end

    summaries
  end

  private

  def compose_url(actor_name)
    escaped_name = CGI.escape(actor_name)

    'https://www.tvkingdom.jp/rss/'\
      'schedulesBySearch.action?'\
      "condition.keyword=#{escaped_name}&"\
      'stationPlatformId=0'
  end

  def get_program_summary(rss_item, channel_to_filters = nil)
    unless channel_to_filters.nil?
      channel_number = extract_channel_number(rss_item.description).to_i
      return nil unless channel_to_filters.include? channel_number
    end

    {
      title: extract_program_title(rss_item.title),
      channel: extract_channel_name(rss_item.description),
      schedule: extract_program_schedule(
        rss_item.date.to_s,
        rss_item.description
      )
    }
  end

  def extract_program_title(raw_title)
    raw_title.gsub(/\[.*?\]/, '')
  end

  def extract_channel_name(raw_description)
    raw_description.match(/\[(.+)\]/)[1]
  end

  def extract_channel_number(raw_description)
    match_data = raw_description.match(/\(Ch.(\d+)\)/)
    match_data[1] unless match_data.nil?
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
