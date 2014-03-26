ETahi.UploadManuscriptOverlayView = Ember.View.extend
  templateName: 'overlays/upload_manuscript_overlay'
  layoutName: 'layouts/assignee_overlay_layout'

  didInsertElement: ->
    new Spinner(top: '0', left: '-64px', color: '#39a329').spin $('.processing')[0]
    $('ul#paper-manuscript-upload, .processing, .progress').hide()

    uploader = $('.js-jquery-fileupload')

    uploader.fileupload
      url: "/papers/#{@controller.get('paper.id')}/upload"
      dataType: 'json'
      method: 'PATCH'

    uploader.on 'fileuploadadd', (e, data) =>
      error = null
      acceptFileTypes = /(\.|\/)(docx)$/i
      if data.originalFiles[0]['name'].length && !acceptFileTypes.test(data.originalFiles[0]['name'])
        @setProperties
          error: "Sorry! '#{data.originalFiles[0]['name']}' is not of an accepted file type"
        e.preventDefault()

    uploader.on 'fileuploadstart', (e, data) =>
      @setProperties
        uploadProgress: 0
        isUploading: true
        isProcessing: false
      $('.progress').show()
      $('ul#paper-manuscript-upload').show()

    uploader.on 'fileuploadprogress', (e, data) =>
      progress = parseInt(data.loaded / data.total * 100.0, 10)
      @set 'progressBarStyle', "width: #{progress}%;"

      if progress >= 100
        $('.progress').hide()
        $('.processing').show()

    uploader.on 'fileuploaddone', (e, data) =>
      @setProperties
        isUploading: false
      $('ul#paper-manuscript-upload').hide()
      $('#task_completed:not(:checked)').click()
      # TODO: make this work AFTER manuscript page is converted to Ember
      # @controoler.transitionToRoute('paper', @get('model.paper'))
      $('.overlay').hide()