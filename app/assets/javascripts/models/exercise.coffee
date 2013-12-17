BurnLevel.Exercise = DS.Model.extend
  routine: DS.belongsTo('routine')
  name: DS.attr('string')