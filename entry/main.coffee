require "/imports/accounts-config.coffee"
require "/imports/api/dosis.coffee"
require "/imports/api/users.coffee"
require "/imports/api/methods.coffee"

if Meteor.isClient
  require "/imports/ui/router.coffee"

# Meteor.startup ->
#   AutoForm.setDefaultTemplate "semanticUI"
