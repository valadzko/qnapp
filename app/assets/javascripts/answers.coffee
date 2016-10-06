window.editAnswerLink = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    return
#window.testTrigger = ->
#  alert('Test trigger called from js!')
#  console.log('Your test trigger works from js!')

$(document).ready(window.editAnswerLink)
$(document).on('turbolinks:load', window.editAnswerLink)
#$(document).on('page:update', window.editAnswerLink)
#$(document).on('page:load', window.editAnswerLink)
