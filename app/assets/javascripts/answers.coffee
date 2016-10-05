$ ->
  $('.edit-answer-link').click (e) ->
    console.log('edit-answer-link clicked')
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    console.log('Your answer id is' + answer_id)
    $('form#edit-answer-' + answer_id).show()
    return
