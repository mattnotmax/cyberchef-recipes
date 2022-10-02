@server
Feature: Query database

In order to persist and retrieve my application data
As a developer
I want to be able to query the database

  Scenario: Query database
    Given a new database server with some example data
     When I query the database
     Then the expected data should be returned

  Scenario: Update a row
    Given a new database server with some example data
     When I update a row in a database table
     Then the updated data should be returned for subsequent queries

  Scenario: Insert a row
    Given a new database server with some example data
     When I insert a new row into a database table
     Then the inserted data should be returned for subsequent queries

  Scenario: Delete a row
    Given a new database server with some example data
     When I delete a row from a database table
     Then the deleted data should not be returned for subsequent queries
