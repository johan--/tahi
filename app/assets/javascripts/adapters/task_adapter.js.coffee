ETahi.TaskAdapter = DS.ActiveModelAdapter.extend
  pathForType: (type) ->
    'tasks'
ETahi.PaperEditorTaskAdapter = ETahi.TaskAdapter.extend()
ETahi.PaperAdminTaskAdapter = ETahi.TaskAdapter.extend()
ETahi.AuthorsTaskAdapter = ETahi.TaskAdapter.extend()
ETahi.MessageTaskAdapter= ETahi.TaskAdapter.extend()
ETahi.TechCheckTaskAdapter= ETahi.TaskAdapter.extend()
ETahi.RegisterDecisionTaskAdapter= ETahi.TaskAdapter.extend()
