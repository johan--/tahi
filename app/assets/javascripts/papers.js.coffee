window.Tahi = {}
Tahi.papers =
  init: ->
    $('#add_author').on 'click', (e) ->
      e.preventDefault()
      li = $('<li class="author">')
      li.html $('#author-template').html()
      li.appendTo $('ul.authors')

  authors: ->
    authorsArray = []
    $('li.author').each (index, value) ->
      authorsArray.push({
        first_name: $(this).children('.author-first-name').text()
        last_name: $(this).children('.author-last-name').text()
        affiliation: $(this).children('.author-affiliation').text()
        email: $(this).children('.author-email').text()
      })
    authorsArray


$(document).ready ->
  if $("[contenteditable]").length > 0
    for elementId in ['body_editable', 'abstract_editable']
      CKEDITOR.inline elementId,
        extraPlugins: 'sharedspace'
        removePlugins: 'floatingspace,resize'
        sharedSpaces:
          top: 'ckeditor-toolbar'
        toolbar: [
          [ 'Styles', 'Format', 'FontSize' ]
          [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ]
          [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', 'Blockquote', 'CreateDiv', 'Table']
          [ 'PasteFromWord' ],
          [ 'Link', 'Unlink', 'Anchor']
          [ 'Find', 'Replace', '-', 'Scayt', '-', 'ShowBlocks' ]
        ]

  $('#save_button').on 'click', (e) ->
    e.preventDefault()
    $.ajax
      url: $(this).data('url') + '.json'
      method: "POST"
      data:
        _method: "patch"
        paper:
          title: $.trim($('#title_editable').text())
          body: CKEDITOR.instances.body_editable.getData()
          abstract: CKEDITOR.instances.abstract_editable.getData()
          short_title: $.trim($('#short_title_editable').text())
          authors: (-> JSON.stringify Tahi.papers.authors())()

      success: ->
        location.href = "/"
    false

  Tahi.papers.init()
