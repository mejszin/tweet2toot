require 'yaml'

require_relative './src/http.rb'
require_relative './src/mastodon.rb'
require_relative './src/twitter.rb'

CONFIG = YAML.load_file('./config.yml')

$twitter = Twitter.new(CONFIG["twitter"]["api"]["base_url"], CONFIG["twitter"]["api"]["bearer_token"])
$mastodon = Mastadon.new(CONFIG["mastodon"]["api"]["base_url"], CONFIG["mastodon"]["api"]["access_token"])

task :run do
    # Initialize values
    delay = CONFIG["settings"]["poll_delay"]
    list_ids = CONFIG["twitter"]["following"]["lists"] == nil ? [] : CONFIG["twitter"]["following"]["lists"]
    user_ids = CONFIG["twitter"]["following"]["users"] == nil ? [] : CONFIG["twitter"]["following"]["users"]
    user_ids.map! { |id| id[0] == '@' ? $twitter.get_user_by_username(id)["id"] : id }
    # Print
    puts "[#{Time.now.to_s}] Starting tweet2mastodon..."
    puts "[#{Time.now.to_s}] List IDs: #{list_ids.inspect}"
    puts "[#{Time.now.to_s}] User IDs: #{user_ids.inspect}"
    # Begin loop
    first_loop, seen_tweet_ids = true, Array.new(1000) { nil }
    while true do
        puts "[#{Time.now.to_s}] Polling..."
        relay_tweets = {}
        # Get tweets by list
        list_ids.each do |list_id|
            $twitter.get_list_tweets(list_id).each do |tweet|
                unless seen_tweet_ids.include?(tweet["id"])
                    relay_tweets[tweet["id"]] = tweet unless first_loop
                    seen_tweet_ids = [tweet["id"]] + seen_tweet_ids[0..-2]
                end
            end
        end
        # Get tweets by user
        user_ids.each do |user_id|
            $twitter.get_user_tweets(user_id).each do |tweet|
                unless seen_tweet_ids.include?(tweet["id"])
                    relay_tweets[tweet["id"]] = tweet unless first_loop
                    seen_tweet_ids = [tweet["id"]] + seen_tweet_ids[0..-2]
                end
            end
        end
        # Relay tweets to Mastadon
        relay_tweets.each do |id, tweet|
            user = $twitter.get_user(tweet["author_id"])
            link = "https://twitter.com/#{user["username"]}/status/#{tweet["id"]}"
            puts "[#{Time.now.to_s}] Found tweet #{link}"
            text = "RT @#{user["username"]}: #{tweet["text"]}\n#{link}"
            http_code = $mastodon.post_toot(text)
            puts "[#{Time.now.to_s}] #{http_code == "200" ? "Posted to" : "(#{http_code}) Could not post to"} #{$mastodon.base_url}"
        end
        # End loop
        first_loop = false
        sleep(delay)
    end
end