GOALS
=====
 - provide easy feed reading for ActiveRecord Models
 - update feed if feed is old (last feed update > 15 minutes)
 - update feed if url has changed 
 - support http://url and url

INSTALL
=======
sudo gem install rss-client

A Model with (see: MIGRATION):
  feed_url : string
  feed_updated_at : timestamp
  feed_data : text

MyFeed < ActiveRecord::Base
  acts_as_feed
end

 
USAGE
=====
 - MyFeed.create!(:feed_url="xxx.com/rss").update_feed
 
 
AUTHOR
======
Michael Grosser
michael dot grosser ät gmail dot com