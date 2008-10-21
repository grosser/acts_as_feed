require 'rss-client'

module ActsAsFeed
  MAX_FEED_ENTRY_DESCRIPTION_LENGTH = 200
  
  def self.included(base) #:nodoc:
    base.extend ClassMethods
  end
  
  class FeedClient
    include RSSClient
    
    def fetch(url)
      opts = OpenStruct.new
      opts.forceUpdate = false # set true to force the download (no 304 code handling)
      opts.giveup = 10         # on error giveup after 10 sec timeout

      rss = get_feed(url,opts)
      return nil unless @rssc_raw             # download error
      return nil if @rssc_raw.status == 304   # feed not modified
      return nil unless rss                   # error in parsing
      rss
    end
  end
  
  module ClassMethods
    def acts_as_feed
      return if self.included_modules.include?(ActsAsFeed::InstanceMethods)
      include ActsAsFeed::InstanceMethods
    end
  end
  
  module InstanceMethods
    def update_feed
      return false unless feed_needs_update?
      return false if feed_url.blank?
      return false unless data = fetch_feed(feed_url)
      self.feed_data = YAML.dump(parse_feed_data(data))
      self.feed_updated_at = Time.now
      save
    end

    #when the feed_url changes, updated_at becomes invalid
    def feed_url=(url)
      self.feed_updated_at = nil unless url == feed_url 
      super(url)
    end
    
  private
  
    def parse_feed_data(data)
      parsed = {}
      parsed[:title] = data.channel.title.to_s
      parsed[:description] = data.channel.description.to_s
      parsed[:entries] = data.entries.map do |entry|
        parse_feed_entry(entry)
      end
      parsed
    end
    
    def parse_feed_entry(entry)
      {:title=>entry.title,:url=>entry.urls[0],:description=>entry.description.to_s[0...MAX_FEED_ENTRY_DESCRIPTION_LENGTH]}
    end

    def fetch_feed(url)
      FeedClient.new.fetch(sane_feed_url(url))
    end
      
    def sane_feed_url(url)
      url.include?('://') ? url : "http://#{url}" 
    end
    
    def feed_needs_update?
      return true if not feed_updated_at
      return true if feed_updated_at < 15.minutes.ago
      false
    end
  end
end