# Methods #
#******************************************************#
def create_visitor
  @visitor ||= { 
    :email => "test@yopmail.com",
    :password => "password", 
    :password_confirmation => "password", 
    :tenant_name => "test" 
  }
end

def invite_visitor
  @invite_visitor ||= { 
    :email => "test1@yopmail.com",  
    :firstname => "first name", 
    :lastname => "last name" 
  }
end

def create_password_visitor
  @password_visitor ||= {
    :password => "password", 
    :password_confirmation => "password"
  }
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, 
    email: @visitor[:email], 
    password: @visitor[:password], 
    password_confirmation: @visitor[:password]
  )
end

def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def sign_in
  visit '/users/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "Sign in"
end

def sign_up
  delete_user
  visit '/users/sign_up'
  fill_in "tenant_name", :with => @visitor[:tenant_name]  
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign up"
  find_user
end

def invite_user
  visit '/members/new'
  fill_in "user_email", :with => @invite_visitor[:email]
  fill_in "user_first_name", :with => @invite_visitor[:firstname]
  fill_in "user_last_name", :with => @invite_visitor[:lastname]
  click_button "Create user and invite"
end

def forget_password
  visit '/users/password/new'
  fill_in "user_email", :with => @visitor[:email]
  click_button "Send me reset password instructions"
end

def create_password_for_invite
  fill_in "user_password", :with => @password_visitor[:password]
  fill_in "user_password_confirmation", :with => @password_visitor[:password_confirmation]
  click_button "Create"
end

def resend_confirmation
  visit '/users/confirmation/new'
  fill_in "user_email", :with => @visitor[:email]
  click_button "Resend"
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end


# Steps  #
#******************************************************#


## Given 
#******************************************************#

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

#Given /^the following user records$/ do |table|
#  table.hashes.each do |hash|  
#    sign_up
#  end
#end

Given /^the following user records$/ do |table|
  table.hashes.each do |hash|  
    FactoryGirl.create(:user, nil)
  end
end

Given /^the following tenant records$/ do |table|
  table.hashes.each do |hash|  
    tenant = FactoryGirl.create(:tenant)
    Thread.current[:tenant_id] = tenant
  end
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |login, password|  
  visit '/users/sign_in'
  fill_in "user_email", :with => login
  fill_in "user_password", :with => password  
  click_button "Sign in"
  sleep 2
end

## Then 
#******************************************************#

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then /^show me the page$/ do
  save_and_open_page
end

## When 
#******************************************************#

When /^I send valid reset password instructions$/ do
  create_visitor
  sign_up
  forget_password
end

When /^I send invalid reset password instructions$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "xtest@yopmail.com")
  forget_password
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I invite user with valid data$/ do
  invite_visitor
  invite_user
end

When /^I create password with valid data$/ do
  create_password_visitor
  create_password_for_invite
end

When /^I resend confirmation with valid user data$/ do
  create_visitor
  sleep 30
  resend_confirmation
end



When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "")
  sign_up
end

When /^I sign up with an empty password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a different password$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "wordpass")
  sign_up
end

When /^I sign in with a wrong email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "test1@yopmail.com")
  sign_in
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

## Email 

Then /^"([^"]*)" receives an email with "([^"]*)" as the subject$/ do |email_address, subject|
  open_email(email_address)
  current_email.subject.should eq subject
end

Then(/^show me$/) do
  save_and_open_page
end