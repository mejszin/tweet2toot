def get_list_tweets(list_id)
    # https://api.twitter.com/2/lists/:id/tweets
    url = "#{CONFIG["twitter"]["api"]["base_url"]}/2/lists/#{list_id}/tweets"
    params = { "max_results" => 5, "tweet.fields" => "created_at,author_id" }
    get(url, params, CONFIG["twitter"]["api"]["bearer_token"])["data"]
end

def get_twitter_users(ids)
    # https://api.twitter.com/2/users
    url = "#{CONFIG["twitter"]["api"]["base_url"]}/2/users"
    params = { "ids" => ids.join(",") }
    get(url, params, CONFIG["twitter"]["api"]["bearer_token"])["data"]
end

def get_user_tweets(user_id)
    # https://api.twitter.com/2/users/:id/tweets
    url = "#{CONFIG["twitter"]["api"]["base_url"]}/2/users/#{user_id}/tweets"
    params = { "max_results" => 5, "tweet.fields" => "created_at,author_id" }
    get(url, params, CONFIG["twitter"]["api"]["bearer_token"])["data"]
end

def get_twitter_user(id)
    get_twitter_users([id]).first
end

def get_twitter_user_by_username(username)
    # https://api.twitter.com/2/users/by/username/:username
    username = username[1..-1] if username[0] == '@'
    url = "#{CONFIG["twitter"]["api"]["base_url"]}/2/users/by/username/#{username}"
    get(url, {}, CONFIG["twitter"]["api"]["bearer_token"])["data"]
end