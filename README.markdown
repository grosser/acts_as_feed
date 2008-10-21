GOALS
=====
 - provide easy feed reading for ActiveRecord Models
 - update feed if feed is old (last feed update > 15 minutes)
 - update feed if url has changed 
 - support http://url and url
 - full test coverage


INSTALL
=======
sudo gem install rss-client
script/plugin install git://github.com/grosser/acts_as_feed.git

Table with (see: MIGRATION):

    feed_url : string
    feed_updated_at : timestamp
    feed_data : text

Simple Model addition:

    User < ActiveRecord::Base
      acts_as_feed
    end
    
Polymorphic Model:

    class Feed < ActiveRecord::Base
      acts_as_feed
      
      belongs_to :covered, :polymorphic => true
      validates_presence_of :covered_id
      
      validates_length_of :feed_url, :in=>10..250
      attr_accessible :feed_url, :covered
      
      after_save :update_feed
    end

 
USAGE
=====
 - call `update_feed` if the feed could be out of date, if it is not, noting will be done
 - `MyFeed.create!(:feed_url="xxx.com/rss").update_feed`
 

 
AUTHOR
======
Michael Grosser
grosser dot michael ät gmail dot com