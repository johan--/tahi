interval = 500
ETahi.EventStream = Em.Object.extend
  eventSource: null
  messageQueue: null
  init: ->
    @set('messageQueue', [])
    params =
      url: '/event_stream'
      method: 'GET'
      success: (data) =>
        return if data.enabled == 'false'
        source = new EventSource(data.url)
        Ember.$(window).unload -> source.close()
        @set('eventSource', source)

        data.eventNames.forEach (eventName) =>
          @addEventListener(eventName)
    Ember.$.ajax(params)
    Ember.run.later(@, 'processMessages', [], interval)

  addEventListener: (eventName) ->
    @get('eventSource').addEventListener eventName, @msgEnqueue.bind(@)

  msgEnqueue: (msg) ->
    @get('messageQueue').unshiftObject(msg)

  processMessages: ->
    unless @get('wait')
      msg = @messageQueue.popObject()
      if msg then @msgResponse(msg)
    Ember.run.later(@, 'processMessages', [], interval)

  pause: ->
    @set('wait', true)

  play: ->
    @set('wait', false)

  msgResponse: (msg) ->
    esData = JSON.parse(msg.data)
    action = esData.action
    meta = esData.meta
    delete esData.meta
    delete esData.action
    if meta
      @eventStreamActions["meta"].call(@, meta.model_name, meta.id)
    else
      (@eventStreamActions[action] || ->).call(@, esData)

  createOrUpdateTask: (action, esData) ->
    taskId = esData.task.id
    if oldTask = @store.findTask(taskId)
      oldPhase = oldTask.get('phase')
    @store.pushPayload('task', esData)
    task = @store.findTask(taskId)
    phase = task.get("phase")
    if action == 'created'
      # This is an ember bug.  A task's phase needs to be notified that the other side of
      # the hasMany relationship has changed via set.  Simply loading the updated task into the store
      # won't trigger the relationship update.
      phase.get('tasks').addObject(task)
    if action == 'updated' && phase != oldPhase
      phase.get('tasks').addObject(task)
      oldPhase.get('tasks').removeObject(oldTask)
      task.set('phase', phase)

    task.triggerLater('didLoad')

  eventStreamActions:
    created: (esData) ->
      Ember.run =>
        if esData.task
          @createOrUpdateTask('created', esData)
        else
          @store.pushPayload(esData)

    updated: (esData)->
      Ember.run =>
        if esData.task
          @createOrUpdateTask('updated', esData)
        else
          @store.pushPayload(esData)

    destroy: (esData)->
      esData.task_ids.forEach (taskId) =>
        task = @store.findTask(taskId)
        if task
          task.deleteRecord()
          task.triggerLater('didDelete')

    meta: (modelName, id) ->
      @set('inFlightRecord', [modelName, id])
      Ember.run =>
        if model = @store.getById(modelName, id)
          model.reload().then =>
            @set('inFlightRecord', null)
        else
          @store.find(modelName, id).then =>
            @set('inFlightRecord', null)
