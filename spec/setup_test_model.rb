require 'rubygems'
require 'active_record'
require 'active_record/fixtures'

#create model table
ActiveRecord::Schema.define(:version => 1) do
  create_table "feeds" do |t|
    t.string    "feed_url"
    t.timestamp "feed_updated_at"
    t.text      "feed_data"
    t.timestamps
  end
end

#create model
class Feed < ActiveRecord::Base
  acts_as_feed
end