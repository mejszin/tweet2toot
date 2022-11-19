class Twitter
    def initialize(base_url, bearer_token)
        @base_url = base_url
        @bearer_token = bearer_token
    end

    def get_list_tweets(list_id)
        # https://api.twitter.com/2/lists/:id/tweets
        url = "#{@base_url}/2/lists/#{list_id}/tweets"
        params = { "max_results" => 5, "tweet.fields" => "created_at,author_id" }
        result = get(url, params, @bearer_token)["data"]
        return result == nil ? [] : result
    end

    def get_users(ids)
        # https://api.twitter.com/2/users
        url = "#{@base_url}/2/users"
        params = { "ids" => ids.join(",") }
        get(url, params, @bearer_token)["data"]
    end
    
    def get_user_tweets(user_id)
        # https://api.twitter.com/2/users/:id/tweets
        url = "#{@base_url}/2/users/#{user_id}/tweets"
        params = { "max_results" => 5, "tweet.fields" => "created_at,author_id" }
        get(url, params, @bearer_token)["data"]
    end
    
    def get_user(id)
        get_users([id]).first
    end
    
    def get_user_by_username(username)
        # https://api.twitter.com/2/users/by/username/:username
        username = username[1..-1] if username[0] == '@'
        url = "#{@base_url}/2/users/by/username/#{username}"
        get(url, {}, @bearer_token)["data"]
    end
end