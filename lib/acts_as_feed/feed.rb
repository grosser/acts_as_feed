module ActsAsFeed
  # == Schema Information
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
    MIN_URL_LENGTH = 6
    acts_as_feed

    #ASSOCIATIONS
    belongs_to :covered, :polymorphic => true

    #ATTRIBUTES
    validates_length_of :feed_url, :in=>MIN_URL_LENGTH..255
    attr_accessible :feed_url, :covered

    #METHODS
    def filled?
      !data.blank?
    end

    #SHORTHAND METHODS
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
      @entries ||= (data[:entries]||[]).map {|data|ActsAsFeed::FeedEntry.new(data)}
    end
  end
end
