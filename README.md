# tweet2toot
Bot that relays tweets from Twitter to Mastodon for consolidating personal feed

## Requirements

- Ruby >2.6.0
- Rake
- Twitter API credentials
- Mastodon API credentials

## Configuration

Add the necessary values to the ``./config.yml`` file:

```yaml
settings:
  poll_delay: 5 # seconds
mastodon:
  api:
    # use the base URL of your mastodon server e.g. https://botsin.space
    base_url: "https://botsin.space"
    access_token: null
twitter:
  api:
    base_url: "https://api.twitter.com"
    bearer_token: null
  following:
    lists:
      # use twitter list IDs
      # - "1275634424898629632"
    users:
      # use twitter user IDs or usernames prefixed by @
      # - "@mejszin"
```

**Note:** My recommendation is to create a list in Twitter called 'Mastodon' for example, and to add users to that - rather than editing the config file and restarting the bot.

## Start the bot

Once the config is set up, from the main directory use the command:

```bash
$ rake run
```
