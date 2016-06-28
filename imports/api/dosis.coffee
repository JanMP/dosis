{ Mongo } = require "meteor/mongo"

Dosis = new Mongo.Collection "dosisdb"
Dosis.schema = new SimpleSchema
  userId :
    type : String
  year :
    type : Number
  month :
    type : Number
  day :
    type : Number
  inTake :
    type : Number
    optional : true
    decimal : true
    min : 0.0
  inr :
    type : Number
    decimal : true
    optional : true
    min : 0.0
    max : 5.0
Dosis.attachSchema Dosis.schema
exports.Dosis = Dosis
