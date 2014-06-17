Feature: Invite other users to my organization
  In order to get access home page with login
  as a user i can invite other users to my organization
  I want to be able send invite to other user

  Scenario: invite other users to my organization
    Given I am on the home page
    When I sign up with valid user data
    And "test@yopmail.com" receives an email with "Confirmation instructions" as the subject
    And I follow "Confirm my account" in the email 
    And I should see "You are already signed in"
    And I invite user with valid data
    Then "test1@yopmail.com" receives an email with "Confirmation instructions" as the subject
    When I follow "Confirm my account" in the email 
    Then I should see "Create password"
    When I create password with valid data
    Then I should see "Your account was successfully confirmed."