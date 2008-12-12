require File.expand_path("spec_helper", File.dirname(__FILE__))
UNRESPONSIVE_URL = 'http://www.fylmz.com'
LARGE_FILE = 'http://ftp.wh2.tu-dresden.de/pub/mirrors/eclipse/technology/epp/downloads/release/ganymede/SR1/eclipse-jee-ganymede-SR1-linux-gtk-x86_64.tar.gz'
PARSEABLE_FEEDS = [
  'http://www.fff.se/rss.asp',
]
CURRENTLY_NOT_PARSABLE_FEEDS = [
  'http://hiff.org/blogger/atom_feed.xml'
]
UNPARSEABLE_FEEDS = [
  'http://blog.soundcloud.com/feed',#redirect
  'www.erikcall.com',#normal page
  'www.glasgowfilmfestival.org.uk/dynamic_pages/feed',#login form
  'http://dotmovfest.blogspot.com/feeds/posts/default',#every line starting with &lt;br /&gt;
]

describe 'reading feeds' do
  PARSEABLE_FEEDS.each do |url|
    it "can read #{url}" do
      Feed.new(:feed_url=>url).update_feed.should be_true
    end
  end

  CURRENTLY_NOT_PARSABLE_FEEDS.each do |url|
    it "should read #{url}" do
      pending do
        Feed.new(:feed_url=>url).update_feed.should be_true
      end
    end
  end


  UNPARSEABLE_FEEDS.each do |wtf|
    it "does not explode on #{wtf}" do
      f = Feed.new(:feed_url=>wtf)
      f.update_feed
      f.feed_data.should be_blank
    end
  end
end


describe "responsiveness" do
  before :all do
    Feed.feed_timeout = 1
  end
  
  it "times out after max 1.5 seconds for large files" do
    duration do
      Feed.new(:feed_url=>LARGE_FILE).update_feed
    end.should < 1.5
  end
  
  it "times out after max 3 seconds for unresponsive urls" do
    pending do
      duration do
  #      Feed.new(:feed_url=>UNRESPONSIVE_URL).update_feed
        #this normally hangs 26 seconds and i am not willing to wait this long for every testrun..
      end.should < 3
      flunk
    end
  end
  
  def duration
    t1 = Time.now
    yield
    Time.now - t1
  end
end
