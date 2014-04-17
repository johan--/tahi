ETahi.ManuscriptManagerTemplateEditController = Ember.ObjectController.extend

  paperTypes: (->
    @get('journal.paperTypes')
  ).property('journal.paperTypes.@each')

  sortedPhases: Ember.computed.alias 'template.phases'

  actions:
    changeTaskPhase: (task, targetPhase) ->

    addPhase: (position) ->
      newPhase = Ember.Object.create name: 'New Phase', tasks: []
      @get('template.phases').insertAt(position, newPhase)

    removePhase: (phase) ->

    removeTask: (task) ->
      taskArray = task.get('phase.tasks')
      taskArray.removeAt(taskArray.indexOf(task))

    savePhase: (phase) ->

    rollbackPhase: (phase, oldName) ->
      phase.set('name', oldName)

