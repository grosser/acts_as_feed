require File.join(File.dirname(__FILE__),'..',"spec_helper")
require File.join(File.dirname(__FILE__),'..','..','lib','acts_as_feed',"feed")
require File.join(File.dirname(__FILE__),'..','..','lib','acts_as_feed',"feed_entry")


class MyFeed < ActsAsFeed::Feed
  #test implementation, 'Feed' is already taken...
end

describe ActsAsFeed::FeedEntry do
  before do
    @data = {:published_at=>1.day.ago,:title=>'My Title',:something=>'else'}
    @entry = ActsAsFeed::FeedEntry.new(@data)
  end

  it "can access all data elements" do
    @entry.title.should == @data[:title]
    @entry.something.should == @data[:something]
  end

  describe :respond_to? do
    [:created_at,:id,:published_at,:something,:title].each do |field|
      it "responds to #{field}" do
        @entry.respond_to?(field).should be_true
      end
    end
  end

  it "redirects created_at to published_at for convenience" do
    @entry.published_at.should == @entry.created_at
  end

  describe :id do
    it "generates a unique id" do
      @entry2 = ActsAsFeed::FeedEntry.new(@data.merge(:published_at=>2.days.ago))
      @entry.id.should_not == @entry2.id
    end

    it "genereates the same id for the same data" do
      @entry2 = ActsAsFeed::FeedEntry.new(@data)
      @entry.id.should == @entry2.id
    end

    it "generates an integer" do
      @entry.id.class.should == Fixnum
    end
  end
end