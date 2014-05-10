# @selenium
# Feature: Dispatch some Responders
#   Dispatchers should be able to dispatch responders to an open report
#   Reports should require at least one Responder to be dispatched

#   Scenario: Assigning no responders
#     Given I am signed in
#     Given I am on the reports page
#     Given there is 1 unassigned report
#     Given there are 3 available responders
#     When I press 'assign responders'
#     Then I see a warning that I must assign at least one responder

#   Scenario: Assigning one responder
#     Given I am signed in
#     Given I am on the reports page
#     Given there is 1 unassigned report
#     Given there are 3 available responders
#     When I click 'John Henry'
#     And I press 'assign responders'
#     Then I see a message saying that I have assigned 'John Henry' to the Report

#   Scenario: Assigning two responders
#     Given I am signed in
#     Given I am on the reports page
#     Given there is 1 unassigned report
#     Given there are 3 available responders
#     When I click 'John Henry'
#     And I click 'Henry Mancini'
#     And I press 'assign responders'
#     Then I see a message saying that I have assigned 'John Henry' to the Report
