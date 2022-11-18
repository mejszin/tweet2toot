class Mastadon
    attr_reader :base_url
    
    def initialize(base_url, access_token)
        @base_url = base_url
        @access_token = access_token
    end

    def post_toot(text = nil)
        url = "#{@base_url}/api/v1/statuses"
        body = { "status" => text }
        post(url, {}, body, @access_token)
    end
end