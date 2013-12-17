BurnLevel.Routine = DS.Model.extend
  exercises: DS.hasMany('exercise')
  name: DS.attr('string')