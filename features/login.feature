@selenium @wip
Feature: Login as Dispatcher
  I should be able to log in

  Scenario: Logging in
    And I am on the home page
    And there is an Agency called 'Las Vegas Rangers'
    And I have an account with 'Las Vegas Rangers' as 'rangers@example.com':'vivalasvegas'
    When I fill in 'email' with 'rangers@example.com'
    When I fill in 'password' with 'vivalasvegas'
    Then I should see Reports for Las Vegas
