#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'

space = ENV['SPACE'] or raise 'Please specify space'
agent = Mechanize.new
agent.verify_mode = 0

page = agent.get("http://single-signon-#{space}.pcfdev.shoetree.io/Home/InvokeJwtSample")
page.body.match('401 (Not Authenticated)') or raise 'Should force Auth'
page.click('Login In')
page.form_with(action: '/login.do') do |f|
  f.username = "user#{space}"
  f.password = 'Password1!'
end.submit
page.body.match('Your About page') or raise 'Should now allow testgroup access'

page.click('Contact')
page.body.match('401 (Not Authenticated)') or raise 'Should not allow testgroup1 access'

page.click('InvokeJwtSample')
page.body.match('Some missing text - should fail') or raise 'Should allow jwt access'
