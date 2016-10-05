# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-question-link').click (e) ->
    console.log('edit-question-link clicked')
    e.preventDefault()
    $(this).hide()
    $('.edit_question').show()
    return
