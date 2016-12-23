createAnswer = (answer) ->
  $('#answers-label').html("Answers:")
  $("#answers-label").after(JST["templates/answer"]({answer: answer}));

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    return

  $('.vote-answer-link').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('#answer-'+ answer.id + ' .voting .errors').empty()
    $('#answer-'+ answer.id + ' .voting .rating').html('<p>Rating: ' + answer.rating + '</p>')
  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('#answer-'+ response.id + ' .voting .errors').html(response.errors)

  App.cable.subscriptions.create({channel: "QuestionsChannel", id: gon.question_id},{
    connected: ->
      @perform 'follow_question_answers',
    ,
    received: (data) ->
      console.log("data from follow_question_answers stream")
      answer = $.parseJSON(data)
      if (gon.user_id != answer.user_id)
        createAnswer(answer)
  })

$(document).ready(ready)
$(document).on("page:load", ready)
$(document).on("page:update", ready)
$(document).on("turbolinks:load", ready)
