coll.dosisDB = new Mongo.Collection "dosisdb"
schem.dosisDB = new SimpleSchema
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
coll.dosisDB.attachSchema schem.dosisDB



