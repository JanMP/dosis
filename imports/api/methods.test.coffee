{ Meteor } = require  "meteor/meteor"
{ Random } = require  "meteor/random"
{ assert } = require  "meteor/practicalmeteor:chai"
{ resetDatabase } = require "meteor/xolvio:cleaner"
{ Dosis } = require "./dosis.coffee"
{ updateInTake } = require "./methods.coffee"

Meteor.methods
  "test.resetDatabase" : -> resetDatabase()

describe "meth.updateInTake", ->

  loggedIn =
    userId : Random.id()

  loggedOut =
    userId : null

  objectPlus =
    year : 2016
    month : 20
    day : 2
    plus : true

  objectMinus =
    year : 2016
    month : 20
    day : 2
    plus : false

  updateInTake =
    Meteor.server.method_handlers["meth.updateInTake"]

  beforeEach (done) ->
    Meteor.call "test.resetDatabase", done

  it "starts out with an empty collection", ->
    assert.equal Dosis.find().count(), 0

  it "can add an item to the collection", ->
    updateInTake.apply loggedIn, [objectPlus]
    assert.equal Dosis.find().count(), 1

  it "throws an error if user isn't logged in", ->
    fn = -> updateInTake.apply loggedOut, [objectPlus]
    assert.throws fn, Meteor.Error

  it "removes an item from the collection, if it removes Intake and INR", ->
    updateInTake.apply loggedIn, [objectPlus]
    assert.equal Dosis.find().count(), 1
    updateInTake.apply loggedIn, [objectMinus]
    assert.equal Dosis.find().count(), 0
