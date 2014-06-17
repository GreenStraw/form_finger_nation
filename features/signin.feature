Feature: User Sign Up Page
  In order to get access home page with login
  As an anonymous user i can sign in for a old account
  I want to be able to sign i
  
  Scenario: Display labels and sign in page
    Given I am on the home page
    And I should see "Sign in"
    When I follow "Sign in"
    Then I should see "Sign in"
    Then I should see "Need to create an account?"
    Then I should see "Forgot your password?"
    Then I should see "Didn't receive confirmation instructions?"
  
  Scenario: Login with Successfull data
    Given I am on the home page
    And I sign up with valid user data
    And "test@yopmail.com" receives an email with "Confirmation instructions" as the subject
    When I follow "Confirm my account" in the email 
    Then I should see "You are already signed in"
    And I should see "My Account"
  
  Scenario: Login with Wrong Data
    Given I am on the sign in page
    When I sign in with a wrong email
    Then I should see "Invalid email or password."