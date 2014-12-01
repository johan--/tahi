`import Ember from 'ember';`
`import DS from 'ember-data';`

Phase = DS.Model.extend
  paper: DS.belongsTo('paper')
  tasks: DS.hasMany('task', polymorphic: true, inverse: 'phase')

  name: DS.attr('string')
  position: DS.attr('number')

  noTasks: Ember.computed.empty('tasks.[]')

`export default Phase;`
