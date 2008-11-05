GOALS
=====
 - Provide easy feed reading for ActiveRecord Models
 - Transparently support RSS and Atom
 - Update feed if feed is old (last feed update > 15 minutes)
 - Update feed if url has changed
 - Support http://url and url
 - Protect from unresponsive sites
 - Protect from giant files
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


DATA USAGE
==========
feed_data is a yaml encoded hash with 

    :title=>'Feed title', :description=>'Feed description', :entries=>[{:title=>xxx,:url=>xxx,:description=>xxx,:published_at=>Time}]

all of these attributes can be blank/nil depending on the feed that was parsed.

    data = YAML.load(feed.feed_data)
    feed_title = data[:title]
    feed_descr = data[:descriptions]
    first_entry_title = data[:entries][0][:title]

 
AUTHOR
======
  Michael Grosser  
  grosser dot michael ät gmail dot com  
