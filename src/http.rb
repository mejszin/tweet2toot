require 'net/http'
require 'uri'
require 'json'

def get(url, headers = {}, bearer = nil)
    uri = URI(url)
    uri.query = URI.encode_www_form(headers) unless headers == {}
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{bearer}" unless bearer == nil
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 500
    http.use_ssl = true
    res = http.start { |h|
        h.request(req)
    }
    return res.code == "200" ? JSON.parse(res.body) : []
end

def post(url, headers = {}, body = nil, bearer = nil)
    uri = URI(url)
    uri.query = URI.encode_www_form(headers)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl, http.verify_mode = true, OpenSSL::SSL::VERIFY_NONE
    headers = { 'Content-Type': 'application/json' }
    headers['Authorization'] = "Bearer #{bearer}" unless bearer == nil
    req = Net::HTTP::Post.new(uri.request_uri, headers)
    req.body = body.to_json unless body == nil
    res = http.request(req)
    return res.code
end