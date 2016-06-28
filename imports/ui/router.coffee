require "/imports/ui/navbar.jade"
require "/imports/ui/info.jade"
require "/imports/ui/graph/graph.coffee"
require "/imports/ui/settings/settings.coffee"

FlowRouter.route "/info",
  name : "info"
  action : ->
    BlazeLayout.render "layout",
      nav : "navbar"
      main : "info"
      footer : "footer"

FlowRouter.route "/",
  name : "home"
  triggersEnter : [AccountsTemplates.ensureSignedIn]
  action : ->
    BlazeLayout.render "layout",
      nav : "navbar"
      main : "graph"
      footer : "footer"

FlowRouter.route "/settings",
  name : "settings"
  triggersEnter : [AccountsTemplates.ensureSignedIn]
  action : ->
    BlazeLayout.render "layout",
      nav : "navbar"
      main : "settings"
      footer : "footer"

FlowRouter.notFound =
  action : ->
    BlazeLayout.render "layout",
      nav : "navbar"
      main : "pageNotFound"
      footer : "footer"

AccountsTemplates.configureRoute "changePwd"
AccountsTemplates.configureRoute "forgotPwd"
AccountsTemplates.configureRoute "resetPwd"
AccountsTemplates.configureRoute "signIn"
AccountsTemplates.configureRoute "signUp"
AccountsTemplates.configureRoute "verifyEmail"
