BurnLevel.RoutinesRoute = Ember.Route.extend
  model: ->
    @store.find 'routine'