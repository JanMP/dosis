{ Dosis } = require "/imports/api/dosis.coffee"

updateInTake = new ValidatedMethod
  name : "meth.updateInTake"
  validate : new SimpleSchema
    year :
      type : Number
    month :
      type : Number
    day :
      type : Number
    plus :
      type : Boolean
  .validator()
  run : ({year, month, day, plus}) ->
    unless @userId
      throw new Meteor.Error "logged-out",
        "User must be logged in to modify data"
    query =
      userId : @userId
      year : year
      month : month
      day : day
    doc = Dosis.findOne query
    if doc?
      if doc.inTake?
        if doc.inTake is 0.25 and not plus
          Dosis.update query,
            $unset :
              inTake : ""
        else
          Dosis.update query,
            $inc :
              inTake : if plus then 0.25 else -0.25
      else if plus
        Dosis.update query,
          $set :
            inTake : 0.25
    else if plus
      query.inTake = 0.25
      Dosis.insert query

updateInr = new ValidatedMethod
  name : "meth.updateInr"
  validate : new SimpleSchema
    year :
      type : Number
    month :
      type : Number
    day :
      type : Number
    inr :
      type : Number
      decimal : true
  .validator()
  run : ({year, month, day, inr}) ->
    unless @userId
      throw new Meteor.Error "logged-out",
        "User must be logged in to modify data"
    query =
      userId : @userId
      year : year
      month : month
      day : day
    doc = Dosis.findOne query
    if doc?
      Dosis.update query,
        $set :
          inr : inr
    else
      query.inr = inr
      Dosis.insert query
