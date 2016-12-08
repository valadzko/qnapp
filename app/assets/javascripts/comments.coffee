# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
publishComment = (comment) ->
  section = $('.comments[commentable_id="' + comment.commentable_id + '"][commentable_type="' + comment.commentable_type + '"]')
  section.children('.comments-label').html("Comments:")
  section.children('.add-comment-form').before(JST["templates/comment"]({comment: comment}))

ready = ->
  App.cable.subscriptions.create({channel: "CommentsChannel", id: gon.question_id},{
    connected: ->
      @perform 'follow_question_page_comments',
    ,
    received: (data) ->
      console.log("data from CommentsChannel stream")
      comment = $.parseJSON(data)
      console.log(comment)
      if (not gon?) || (gon.user_id != comment.user_id)
        publishComment(comment)
  })

$(document).ready(ready)
