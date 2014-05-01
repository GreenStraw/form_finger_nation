#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require handlebars
#= require_self
#= require auth
#= require app

window.App = Em.Application.create
  LOG_TRANSITIONS: true

#= require_tree .
