require File.join(File.dirname(__FILE__),'..',"spec_helper")
require File.join(File.dirname(__FILE__),'..','..','lib','acts_as_feed',"feed")
require File.join(File.dirname(__FILE__),'..','..','lib','acts_as_feed',"feed_entry")


class MyFeed < ActsAsFeed::Feed
  #test implementation, Feed is already taken...
end

describe ActsAsFeed::Feed do
  before do
    @feed = MyFeed.new(:feed_url=>'mypage.com/rss.xml')
  end

  describe :validations do
    it "is valid" do
      @feed.should be_valid
    end

    it "is not valid with too short url" do
      @feed.feed_url = 'xcx'
      @feed.should_not be_valid
    end
  end

  [:title,:description].each do |field|
    describe field do
      it "has a #{field} when data is filled" do
        @feed.feed_data = YAML.dump(field=>'xx')
        @feed.send(field).should == 'xx'
      end

      it "has no #{field} when data is empty" do
        @feed.feed_data = ''
        @feed.send(field).should be_nil
      end
    end
  end

  describe :entries do
    it "has no entries wen theya are empty" do
      @feed.feed_data = ''
      @feed.entries.should == []
    end

    it "has on entry for each feed entry" do
      @feed.feed_data = YAML.dump({:entries=>[{},{}]})
      @feed.entries.size.should == 2
    end

    it "transfers data to entries" do
      @feed.feed_data = YAML.dump({:entries=>[{:title=>'x'},{:title=>'y'}]})
      @feed.entries.first.title.should == 'x'
    end
  end

  describe :filled? do
    it "is filled when there is data" do
      @feed.feed_data = YAML.dump(:title=>'xxx')
      @feed.should be_filled
    end

    it "is not filled if data is empty" do
      @feed.should_not be_filled
    end
  end

  it "handles empty feed" do
    @feed.feed_data = nil
    @feed.data.should == {}
    @feed.title.should be_nil
  end
end
