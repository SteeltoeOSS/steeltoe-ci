#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'json'
require 'uri'

space = ENV['SPACE'] or raise 'Please specify space'
uri = URI("http://fortuneui-#{space}.pcfdev.shoetree.io/random")
puts "Check #{uri}"
# => {"id"=>1021, "text"=>"The greatest risk is not taking one."}
res = Net::HTTP.get_response(uri)
raise "Received #{res.code}" unless res.is_a?(Net::HTTPSuccess)
json = JSON.parse(res.body)

json['id'].to_i > 0 or raise "JSON did not return an id"
json['text'].to_s.length > 0 or raise "JSON did not return text"

system('./cf-space/login') if File.exists?('./cf-space/login')
system('cf', 'stop', 'fortuneService')

res = Net::HTTP.get_response(uri)
raise "Expected 500 after stopping service" if res.is_a?(Net::HTTPSuccess)

puts "Success"
