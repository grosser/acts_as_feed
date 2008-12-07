require File.expand_path("spec_helper", File.dirname(__FILE__))
UNRESPONSIVE_URL = 'http://www.fylmz.com'
LARGE_FILE = 'http://ftp.wh2.tu-dresden.de/pub/mirrors/eclipse/technology/epp/downloads/release/ganymede/SR1/eclipse-jee-ganymede-SR1-linux-gtk-x86_64.tar.gz'
UNPARSEABLE_FEEDS = [
  'http://dotmovfest.blogspot.com/feeds/posts/default'
]

PARSEABLE_FEEDS = [
  'http://www.fff.se/rss.asp',
  'http://hiff.org/blogger/atom_feed.xml'
]

describe 'reading feeds' do
  PARSEABLE_FEEDS.each do |feed|
    it "can read #{feed}" do
      Feed.new(:feed_url=>feed).update_feed.should be_true
    end
  end

  UNPARSEABLE_FEEDS.each do |wtf|
    it "does not explode on #{wtf}" do
      Feed.new(:feed_url=>wtf).update_feed
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
