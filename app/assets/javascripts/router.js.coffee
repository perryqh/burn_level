# For more information see: http://emberjs.com/guides/routing/

BurnLevel.Router.map ()->
  @resource 'routines', ->
    @resource 'routine', path: ':routine_id'

