FlowRouter.route "/info",
  name : "info"
  action : ->
    BlazeLayout.render "layout",
      nav : "nav"
      main : "info"
      footer : "footer"

FlowRouter.route "/",
  name : "home"
  triggersEnter : [AccountsTemplates.ensureSignedIn]
  action : ->
    BlazeLayout.render "layout",
      nav : "nav"
      main : "graph"
      footer : "footer"

FlowRouter.route "/settings",
  name : "settings"
  triggersEnter : [AccountsTemplates.ensureSignedIn]
  action : ->
    BlazeLayout.render "layout",
      nav : "nav"
      main : "settings"
      footer : "footer"

FlowRouter.notFound =
  action : ->
    BlazeLayout.render "layout",
      nav : "nav"
      main : "pageNotFound"
      footer : "footer"

AccountsTemplates.configureRoute "changePwd"
AccountsTemplates.configureRoute "forgotPwd"
AccountsTemplates.configureRoute "resetPwd"
AccountsTemplates.configureRoute "signIn"
AccountsTemplates.configureRoute "signUp"
AccountsTemplates.configureRoute "verifyEmail"
