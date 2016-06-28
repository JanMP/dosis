userProfileSchema = new SimpleSchema
  startYear :
    type : Number
    min : 1980
    max : 2050
    defaultValue : 2015
  startMonth :
    type : Number
    min : 1
    max : 12
    defaultValue : 1
  endYear :
    type : Number
    min : 1980
    max : 2030
    defaultValue : 2015
  endMonth :
    type : Number
    min : 1
    max : 12
    defaultValue : 1

userSchema = new SimpleSchema
  username :
    type : String
    optional : true
  emails :
    type : Array
    optional : true
  "emails.$" :
    type : Object
  "emails.$.address" :
    type : String
    regEx : SimpleSchema.RegEx.Email
  "emails.$.verified" :
    type : Boolean
  createdAt :
    type : Date
  profile :
    type : userProfileSchema
    optional : true
  services :
    type : Object
    optional : true
    blackbox : true
  roles :
    type : [String]
    optional : true
  heartbeat :
    type : Date
    optional : true

Meteor.users.attachSchema userSchema
