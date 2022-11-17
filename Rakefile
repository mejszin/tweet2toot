require 'yaml'

require_relative './src/http.rb'
require_relative './src/mastodon.rb'
require_relative './src/twitter.rb'

CONFIG = YAML.load_file('./config.yml')

task :relay do
    # Initialize values
    delay = CONFIG["settings"]["poll_delay"]
    list_ids = CONFIG["twitter"]["following"]["lists"] == nil ? [] : CONFIG["twitter"]["following"]["lists"]
    user_ids = CONFIG["twitter"]["following"]["users"] == nil ? [] : CONFIG["twitter"]["following"]["users"]
    user_ids.map! { |id| id[0] == '@' ? get_twitter_user_by_username(id)["id"] : id }
    # Begin loop
    first_loop, seen_tweet_ids = true, Array.new(1000) { nil }
    while true do
        puts 'Polling...'
        relay_tweets = {}
        # Get tweets by list
        list_ids.each do |list_id|
            get_list_tweets(list_id).each do |tweet|
                unless seen_tweet_ids.include?(tweet["id"])
                    relay_tweets[tweet["id"]] = tweet unless first_loop
                    seen_tweet_ids = [tweet["id"]] + seen_tweet_ids[0..-2]
                end
            end
        end
        # Get tweets by user
        user_ids.each do |user_id|
            get_user_tweets(user_id).each do |tweet|
                unless seen_tweet_ids.include?(tweet["id"])
                    relay_tweets[tweet["id"]] = tweet unless first_loop
                    seen_tweet_ids = [tweet["id"]] + seen_tweet_ids[0..-2]
                end
            end
        end
        # Relay tweets to Mastadon
        relay_tweets.each do |id, tweet|
            user = get_twitter_user(tweet["author_id"])
            link = "https://twitter.com/#{user["username"]}/status/#{tweet["id"]}"
            text = "RT @#{user["username"]}: #{tweet["text"]}\n#{link}"
            puts text
            post_toot(text)
        end
        # End loop
        first_loop = false
        sleep(delay)
    end
end