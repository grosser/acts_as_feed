namespace :feed do
  desc "update all feeds"
  task :update do
    updated = []
    errors = 0

    Feed.all.each do |feed|
      updated << feed.update_feed

      feed_could_be_read = (updated.last or feed.filled?)
      unless feed_could_be_read
        errors += 1
        puts "Error on: #{feed.feed_url}"
      end
    end

    puts "#{updated.select{|x|x}.size} of #{updated.size} Feeds updated (with #{errors} errors)"
  end
end