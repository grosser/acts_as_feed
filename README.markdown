GOALS
=====
 - Provide easy feed reading for ActiveRecord Models
 - Update feed if feed is old (last feed update > 15 minutes)
 - Update feed if url has changed 
 - Support http://url and url
 - Full test coverage


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
      acts_as_feed :timeout=>3 #seconds
      
      belongs_to :covered, :polymorphic => true
      validates_presence_of :covered_id
      
      validates_length_of :feed_url, :in=>10..250
      attr_accessible :feed_url, :covered
      
      after_save :update_feed
    end

 
USAGE
=====
 - Call `update_feed` if the feed could be out of date. If it is not, noting will be done.
 - `MyFeed.create!(:feed_url="xxx.com/rss").update_feed`
 

TODO
====
 - Protect against unresponsive urls (www.fylmz.com) 

 
AUTHOR
======
  Michael Grosser  
  grosser dot michael ät gmail dot com  