# require 'dotenv'
require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'pry'

# check forum domain state on Mailgun
forum = JSON.parse(RestClient.get(
  "https://api:key-1cde62564b46b998cf36c0f4b59281a3"\
  "@api.mailgun.net/v3/domains/newforum.phillyrollergirls.com"))

# quit if the domain is in good shape
exit if forum["state"] == "active"

# find demon record that keeps disappearing
smtp_record = forum["sending_dns_records"].detect do |record|
  record["name"].start_with? 'smtp'
end

name    = smtp_record["name"]
type    = smtp_record["record_type"]
address = smtp_record["value"]
ttl     = "600"

# re-add record to cPanel
doc = Nokogiri::HTML(open(URI.parse "https://securem22.sgcpanel.com:2083/"))
require 'pry'; binding.pry
