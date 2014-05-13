@selenium @wip
Feature: Login as Dispatcher
  I should be able to log in

  Scenario: Logging in
    And I am on the home page
    And I have an account with login info as 'rangers@example.com':'vivalasvegas'
    When I fill in 'email' with 'rangers@example.com'
    When I fill in 'password' with 'vivalasvegas'
    Then I should see Reports for Las Vegas
