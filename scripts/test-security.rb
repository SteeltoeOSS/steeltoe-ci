#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'json'

space = ENV['SPACE'] or raise 'Please specify space'
agent = Mechanize.new
agent.verify_mode = 0

page = agent.get("http://single-signon-#{space}.pcfdev.shoetree.io/Home/About")
page.uri.to_s.match('https://login.pcfdev.shoetree.io/login') or raise 'Should force Auth'
page = page.form_with(action: '/login.do') do |f|
  f.username = "user#{space}"
  f.password = 'Password1!'
end.submit
page.uri.to_s.match("http://single-signon-#{space}.pcfdev.shoetree.io/Home/About") or raise "Should have redirected to About"
page.body.match('Your About page') or raise 'Should now allow testgroup access'

page = page.link_with(:href => /Contact/).click
page.body.match('Insufficient permissions') or raise 'Should not allow testgroup1 access'

page = page.link_with(:href => /InvokeJwtSample/).click
page.body.match('Invoke Jwt Sample Application') or raise 'Should allow jwt access'
values = JSON.parse(page.search('h3').text)
values == ["value1","value2"] or raise 'Should display values from jwt api'

puts "Test Passed"
