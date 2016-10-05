#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'json'

space = ENV['SPACE'] or raise 'Please specify space'
agent = Mechanize.new
agent.verify_mode = 0

puts "Start"
page = agent.get("http://musicui-#{space}.cfapps.pez.pivotal.io/")

puts "View Classical Genre"
page = page.link_with(href: /Genre=Classical/).click
page.search('div.genre h3:first').text.strip == "Classical Albums" or raise "Expected H3 of Classical Albums"

puts "View Single Album"
page = page.link_with(text: /Purcell: The Fairy Queen/).click
page.search('h2:first').text.strip == "Purcell: The Fairy Queen" or raise "Expected H2 of Purcell: The Fairy Queen"

puts "Add to Cart"
page = page.link_with(text: /Add to cart/).click

puts "Attempt to Checkout"
page.search('h3:first').text.strip == "Review your cart:" or raise "Expected H3 of Review your cart:"
page = page.link_with(text: /Checkout >>/).click
page.search('h4:first').text.strip =~ /Use a local account to log in/ or raise "Expected H4 of Use a local account to log in"

puts "Register"
page = page.link_with(text: /Register as a new user?/).click
page = page.form_with(action: '/Account/Register') do |f|
  f.Email = 'user@example.com'
  f.Password = 'Pass1!'
  f.ConfirmPassword = 'Pass1!'
end.submit
page.search('h1:first').text.strip =~ /Demo link display page/ or raise "Expected H1 of Demo link display page"

puts "Login"
page = page.link_with(text: /Log in/).click
page = page.form_with(action: '/Account/Login') do |f|
  f.Email = 'user@example.com'
  f.Password = 'Pass1!'
end.submit
page.search('.navbar a[title=Manage]').text.strip == 'Hello user@example.com!' or raise 'Login Failed'

puts "Checkout"
page = page.link_with(href: '/ShoppingCart').click
page = page.link_with(text: /Checkout >>/).click
page = page.form_with(action: '/Checkout/AddressAndPayment') do |f|
  f.FirstName = 'Fred'
  f.LastName = 'Example'
  f.Address = '625 6th Ave'
  f.City = 'New York'
  f.State = 'NY'
  f.PostalCode = '10011'
  f.Country = 'USA'
  f.Phone = '(666) 792-5770'
  f.Email = 'user@example.com'
  f.PromoCode = 'FREE'
end.submit
page.search('h2:first').text.strip =~ /Checkout Complete/ or raise "Expected H4 of Checkout Complete"

puts "Login as admin"
page = page.form_with(action: "/Account/LogOff").submit
page = page.link_with(text: /Log in/).click
page = page.form_with(action: '/Account/Login') do |f|
  f.Email = 'Administrator@test.com'
  f.Password = 'YouShouldChangeThisPassword1!'
end.submit
page.search('.navbar a[title=Manage]').text.strip == 'Hello Administrator@test.com!' or raise 'Admin Login Failed'

puts "View StoreManager"
page = page.link_with(text: /admin/).click
page.link_with(text: /Create New/).text.strip =~ /Create New/ or raise "Expected link of Create New"

puts "Test Passed"
