Feature: Home Page
  In order to get access home page without login
  As an anonymous user i can view the root url
  I want able to display static text

  Scenario: an anonymous user i can view the root url
    Given I am on the home page
    And I should see "Sign in"
    And I should see "Sign up"
    And I should see "Hello, BaseAppers"
    And I should not see "My Account"
  
