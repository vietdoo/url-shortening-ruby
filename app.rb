require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'securerandom'

set :database, { adapter: "sqlite3", database: "url_shortener.db" }

# URL Model
class Url < ActiveRecord::Base
  validates :original_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :short_code, uniqueness: true
end

# Encode: shorten a URL
post '/encode' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  original_url = request_body['url']

  # Validate URL
  unless original_url =~ URI::DEFAULT_PARSER.make_regexp
    halt 400, { error: "Invalid URL format" }.to_json
  end

  # Check if URL already encoded
  url = Url.find_by(original_url: original_url)
  if url
    { short_url: "#{request.base_url}/#{url.short_code}" }.to_json
  else
    # Generate unique short code
    begin
      short_code = SecureRandom.alphanumeric(6)
    end while Url.exists?(short_code: short_code)

    # Persist to database
    url = Url.create!(original_url: original_url, short_code: short_code)
    { short_url: "#{request.base_url}/#{url.short_code}" }.to_json
  end
end

# Decode: get the original URL from a short URL
post '/decode' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  short_url = request_body['short_url']

  # Extract short code
  short_code = short_url.split('/').last
  url = Url.find_by(short_code: short_code)

  if url
    { original_url: url.original_url }.to_json
  else
    halt 404, { error: "Short URL not found" }.to_json
  end
end
