#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'json'


space = ENV['SPACE'] or raise 'Please specify space'
puts "Check http://fortuneui-#{space}.pcfdev.shoetree.io/random"
# => {"id"=>1021, "text"=>"The greatest risk is not taking one."}
body Net::HTTP.get("fortuneui-#{space}.pcfdev.shoetree.io", '/random')
json = JSON.parse(body)

json['id'].to_i > 0 or raise "JSON did not return an id"
json['text'].to_s.length > 0 or raise "JSON did not return text"

puts "Success"
