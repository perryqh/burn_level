BurnLevel.RoutinesController = Ember.ArrayController.extend
  actions:
    createNewRoutine: (name) ->
      routine = this.store.createRecord('routine', name: this.get('newRoutineName'))
      routine.save()
      this.set('newRoutineName', null)