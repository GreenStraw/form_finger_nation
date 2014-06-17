Feature: User Sign Up Page
  In order to get access home page with login
  As an anonymous user i can sign up for a new account
  I want to be able to sign up

  Scenario: user sign up with valid information
    Given I am on the sign up page
    And I should see "Sign up"
    When I sign up with valid user data
    And "test@yopmail.com" receives an email with "Confirmation instructions" as the subject
    And I follow "Confirm my account" in the email 
    Then I should see "You are already signed in"
  
  Scenario: User signs up with blank email account
    Given I am on the sign up page
    And I should see "Sign up"
    When I sign up with an invalid email
    Then I should see "can't be blank"
  
  Scenario: User signs up with blank password account
    Given I am on the sign up page
    When I sign up with an empty password
    Then I should see "can't be blank"
  
  Scenario: User signs up with mismatch password and password confirmation
    Given I am on the sign up page
    When I sign up with a different password
    Then I should see "Password confirmation doesn't match"