Features
========
 - Easy feed reading for ActiveRecord Models
 - Transparently support RSS and Atom
 - Update feed if feed is old (last feed update > 15 minutes)
 - Update feed if url has changed
 - Support http://url and url
 - Protect from unresponsive sites
 - Protect from giant files
 - Basic implementation of Feed and FeedEntry
 - Full test coverage


INSTALL
=======

    sudo gem install rss-client
    script/plugin install git://github.com/grosser/acts_as_feed.git

Table with (see: MIGRATION):

    #essential
    feed_url : string
    feed_updated_at : timestamp
    feed_data : text

    #if you want to extend use a polymorphic feed
    covered_id : integer
    covered_type : string

Simple Model addition:

    User < ActiveRecord::Base
      acts_as_feed
    end
    
Polymorphic Model:

    #leverage basic implementation (see lib/acts_as_feed/feed)
    class Feed < ActsAsFeed::Feed
      belongs_to :covered, :polymorphic => true
      attr_accessible :feed_url, :covered
      after_save :update_feed
    end

    #roll you own
    class Feed < ActiveRecord::Base
      acts_as_feed :timeout=>3 #seconds
      
      belongs_to :covered, :polymorphic => true
      
      validates_length_of :feed_url, :in=>10..250
      attr_accessible :feed_url, :covered
      
      after_save :update_feed
    end


USAGE
=====
 - Call `update_feed` if the feed could be out of date. If it is not, noting will be done.
 - `MyFeed.create!(:feed_url="xxx.com/rss").update_feed`


DATA USAGE
==========
!If you do not extend `ActsAsFeed::Feed` please read `/examples/raw_data_usage.txt`!

    #HAML view example
    - if feed.filled?
      %h2="Blog: #{feed.title}"
      - for item in feed.entries[0...5]
        -date = item.published_at.to_date.to_s(:long) rescue ''#can be nil depending on parsed feed

        %h2=link_to(h(item.title),h(item.url))
        %br
        =date
        %br
        - unless item.description.blank?
          =truncate(item.description,70)  #description is always cleared with strip_tags

Alternatives
============
If you only want to display the feeds contents to browser-using-users, try
Googles Feed API instead.  
[Google Feed API](http://code.google.com/apis/ajaxfeeds/)
[Google Feed API example](http://pragmatig.wordpress.com/2009/01/28/parsing-rss-feeds-via-googles-js-feed-api/)


 
AUTHOR
======
  Michael Grosser  
  grosser dot michael ät gmail dot com  
