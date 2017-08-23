require "json/ext"
require "open-uri"
require "rest-client"
require "rss"
require "rufus-scheduler"

ENV["TZ"] = "America/Chicago"

scheduler = Rufus::Scheduler.new

add_endpoint = "https://www.instapaper.com/api/add"

username = ENV["INSTAPAPER_USERNAME"]
password = ENV["INSTAPAPER_PASSWORD"]
rss_feed_urls = ENV["RSS_FEED_URLS"].split(",")

scheduler.every "5m" do
  rss_feed_urls.each do |feed_url|
    open(feed_url) do |rss|
      feed = RSS::Parser.parse(rss)

      feed.items.each do |feed_item|
        title = if feed_item.title.is_a?(String)
          feed_item.title
        else
          feed_item.title.content
        end

        url = if feed_item.link.is_a?(String)
          feed_item.link
        else
          feed_item.link.href
        end

        file_path = File.join(Dir.pwd, "data", "urls.log")
        is_already_bookmarked = File.open(file_path, "rb").read.include?(url)

        unless is_already_bookmarked
          RestClient.post(
            add_endpoint,
            {
              username: username,
              password: password,
              url: url,
              title: title
            }
          )

          `echo '#{url}' >> #{file_path}`
        end
      end
    end
  end
end

scheduler.join
