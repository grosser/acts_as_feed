# == Schema Information
# Table name: feeds
#
#  id              :integer(11)     not null, primary key
#  feed_url        :string(255)     
#  feed_data       :text            
#  feed_updated_at :datetime        
#  covered_type    :string(255)     
#  covered_id      :integer(11)     
#  created_at      :datetime        
#  updated_at      :datetime        
# == Schema Information
class Feed < ActiveRecord::Base
  acts_as_feed
  
  #ASSOCIATIONS
  belongs_to :covered, :polymorphic => true
  
  #ATTRIBUTES
  attr_accessible :feed_url, :covered
  
  #METHODS
  def filled?
    !data.blank?
  end
  
  def data
    @data ||= feed_data.blank? ? {} : YAML.load(feed_data)
  end
  
  def title
    data[:title]
  end
  
  def description
    data[:description]
  end
  
  def entries
    @entries ||= data[:entries].map {|data|FeedEntry.new(data)}
  end
end
