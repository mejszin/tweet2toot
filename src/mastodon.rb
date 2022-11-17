def post_toot(text = nil)
    url = "#{CONFIG["mastodon"]["api"]["base_url"]}/api/v1/statuses"
    body = { "status" => text }
    post(url, {}, body, CONFIG["mastodon"]["api"]["access_token"])
end