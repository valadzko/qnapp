ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    return

$(document).ready(ready)
$(document).on("page:load", ready)
$(document).on("page:update", ready)
$(document).on("turbolinks:load", ready)
