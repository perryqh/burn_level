#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require foundation
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require burn_level
#= require_tree .

# for more details see: http://emberjs.com/guides/application/
window.BurnLevel = Ember.Application.create(LOG_TRANSITIONS: true)


$ = jQuery
$.fn.myFunction = ->
  $(document).foundation()

