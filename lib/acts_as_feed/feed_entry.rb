module ActsAsFeed
  #entries have a id so that feed_entries can be published in another aggregated feed
  class FeedEntry
    def initialize(data)
      @data=data
    end

    #convenience
    def created_at
      published_at
    end

    #return something unique and non-changing
    def id
      (published_at.to_date.to_s(:db).gsub('-','') + published_at.min.to_s + published_at.sec.to_s).to_i
    end

    def method_missing(method)
      @data[method.to_sym]
    end

    def respond_to?(method)
      super or !!@data[method.to_sym]
    end
  end
end