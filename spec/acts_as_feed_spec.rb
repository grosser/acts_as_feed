require File.expand_path("spec_helper", File.dirname(__FILE__))
TEST_FEED = 'rubyforge.org/export/rss_sfnews.php'


describe "parsing a feed" do
  before :all do
    @feed = Feed.new(:feed_url=>TEST_FEED)
    @feed.update_feed
    @data = YAML.load(@feed.feed_data)
  end
  
  it "reads the title" do
    @data[:title].should == 'RubyForge Project News'
  end
  
  it "reads the description" do
    @data[:description].should == 'RubyForge Project News Highlights'
  end
  
  it "reads entries" do
    size = 10
    @data[:entries].size.should == size
    size.times do |i|
      @data[:entries][i][:title].should_not be_blank
      @data[:entries][i][:url].should_not be_blank
    end
  end
end


describe "obeying timeout" do
  before :all do
    class DeadFeed < ActiveRecord::Base
      set_table_name :feeds
      acts_as_feed :timeout => 0.00001
    end
  end
    
  it "cannot fetch if timeout is too small" do
    @feed = DeadFeed.new(:feed_url=>TEST_FEED)
    t1 = Time.now
    @feed.update_feed
    (Time.now - t1).should < 0.1
  end
  
  it "does not overwrite timeouts" do
    Feed.feed_timeout.should_not == DeadFeed.feed_timeout
  end
end


describe :acts_as_feed do
  it "included instance methods" do
    Feed.included_modules.include?(ActsAsFeed::InstanceMethods).should be_true
  end
end


describe :update_feed do
  before do
    @feed = Feed.new(:feed_url=>'xxx')
    @feed.stubs(:feed_needs_update?).returns true
    @feed.stubs(:fetch_feed).returns []
  end
  
  it "does not fetch if feed was recently fetched" do
    @feed.expects(:feed_needs_update?).returns false
    @feed.expects(:feed_url).never
    @feed.update_feed.should be_false
  end
  
  it "does not fetch if feed if url is blank" do
    @feed.expects(:feed_url).returns nil
    @feed.expects(:fetch_feed).never
    @feed.update_feed.should be_false
  end
  
  it "does not store if feed could not be fetched" do
    @feed.expects(:fetch_feed).returns nil
    @feed.update_feed.should be_false
  end
  
  describe "successfully fetching a feed" do
    before do
      @feed.expects(:fetch_feed).returns "data1"
      @feed.expects(:parse_feed_data).with("data1").returns "data"
      @feed.update_feed.should be_true
    end
    
    it "stored the feed data as yaml" do
      @feed.reload.feed_data.should == "--- data\n"
    end
    
    it "updates the feed_updated_at" do
      @feed.reload.feed_updated_at.to_i.should == Time.now.to_i
    end
  end
end


describe :feed_needs_update? do
  def status(hash={})
    Feed.new(hash).send(:feed_needs_update?)
  end
  
  it "is true when updated_at is not set" do
    status.should be_true
  end
  
  it "is true when feed_url was changed" do
    f = Feed.new(:feed_updated_at=>Time.now)
    f.feed_url = 'xxxx'
    f.send(:feed_needs_update?).should be_true
  end
  
  it "is false when feed_url was not changed" do
    status(:feed_updated_at=>Time.now).should be_false
  end
  
  it "is false when feed was fetched less than 15min ago" do
    status(:feed_updated_at=>14.minutes.ago).should be_false
  end
  
  it "is true when feed was fetched > 15min ago" do
    status(:feed_updated_at=>16.minutes.ago).should be_true
  end
end


describe :feed_url= do
  before do
    @feed = Feed.new(:feed_url=>'xxx')
    @feed.feed_updated_at=Time.now
  end
  
  it "resets feed_updated_at if url has changed" do
    @feed.feed_url = 'new'
    @feed.feed_updated_at.should be_nil
  end
  
  it "does not reset feed_updated_at if url has not changed" do
    @feed.feed_url = @feed.feed_url
    @feed.feed_updated_at.should_not be_nil
  end
end


describe :fetch_feed do
  before do
    ActsAsFeed::FeedClient.any_instance.expects(:fetch).with('http://hello',Feed.feed_timeout).returns "data"
  end
  
  it "calls FeedClient.fetch" do
    Feed.new.send(:fetch_feed,'http://hello').should == "data"
  end
  
  it "it adds http:// if necessary" do
    Feed.new.send(:fetch_feed,'hello')
  end
end


describe :parse_feed_data do
  def parsed
    data = stub(:channel=>stub(:title=>'the title',:description=>'the description'),:entries=>[stub(:title=>'entry 1',:urls=>['url 1'],:description=>"descr"*100)])
    @feed.send(:parse_feed_data,data)
  end
  
  before do
    @feed = Feed.new
  end
  
  it "reads the title" do
    parsed[:title].should == 'the title'
  end
  
  it "reads the description" do
    parsed[:description].should == 'the description'
  end
  
  it "reads the entries title" do
    parsed[:entries][0][:title].should == 'entry 1'
  end
  
  it "reads the entries url" do
    parsed[:entries][0][:url].should == 'url 1'
  end
  
  it "reads the description" do
    parsed[:entries][0][:description].length.should == 200
  end
end