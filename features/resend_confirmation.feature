Feature: request to resend validation token
  In order to get access home page with login
  as an anonymous user i can request to resend validation token
  I want to be able resend validation token

  Scenario: request to resend validation token
    Given I am on the sign up page
    And I sign up with valid user data
    When I resend confirmation with valid user data
    Then "test@yopmail.com" receives an email with "Confirmation instructions" as the subject