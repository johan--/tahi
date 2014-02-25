window.Tahi ||= {}

Tahi.utils =
  windowHistory: ->
    window.history
  resizeContainer: (selector, child) ->
    heights = $(selector).find(child).map ->
      $(this).outerHeight(true)
    max = Math.max.apply(Math, heights);
    $(selector).css('height', max);
