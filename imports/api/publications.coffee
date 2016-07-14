{ Meteor } = require "meteor/meteor"
{ Dosis } = require "/imports/api/dosis.coffee"

Meteor.publish "dosis.userData", ->
  Dosis.find userId : @userId

  
