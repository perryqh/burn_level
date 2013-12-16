# For more information see: http://emberjs.com/guides/routing/

BurnLevel.Router.map ()->
  @resource 'routines', path: '/', ->
    @resource 'routine', path: '/routines/:routine_id'

