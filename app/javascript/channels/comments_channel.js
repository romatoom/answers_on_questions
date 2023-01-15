import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const templateComment = require('../templates/comment.hbs');

  consumer.subscriptions.create("CommentsChannel", {
    connected() {
      console.log("Connected to comments channel");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.sid === data.sid) return;

      const comment_type = data.comment.commenteable_type

      const commentHTML = templateComment(data);

      switch (comment_type) {
        case 'Question':
          $('.question .comments').append(commentHTML);
          break;
        case 'Answer':
          $('#answer_' + data.comment.commenteable_id + ' .comments').append(commentHTML);
          break;
        default:
      }
    }
  });
});
