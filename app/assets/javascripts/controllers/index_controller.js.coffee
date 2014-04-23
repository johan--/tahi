ETahi.IndexController = Ember.ObjectController.extend
  currentUser:(-> Tahi.currentUser).property()
  hasSubmissions: Ember.computed.notEmpty('model.submissions')
  hasAssignedTasks: Ember.computed.notEmpty('model.assignedTasks')

  tasksByPaper:(->
    obj = _(this.get('assignedTasks').content).groupBy((t)-> t.get('paper.id'))
    _(obj).map (tasks, paper_id)->
      paper = tasks[0].get('paper')
      { shortTitle: paper.get('shortTitle'), id: paper.get('id'), tasks: tasks }
  ).property('model.assignedTasks.@each')

