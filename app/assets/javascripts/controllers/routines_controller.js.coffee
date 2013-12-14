BurnLevel.RoutinesController = Ember.ArrayController.extend
  addRoutine: (name) ->
    BurnLevel.Routine.createRecord(name: name)
    @get('store').commit()