import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const question_id = gon.question_id;
  if (!question_id) return;

  const templateAnswer = require('../templates/answer.hbs');
  const answersList = $('.answers')

  consumer.subscriptions.create({ channel: "QuestionChannel", question_id: question_id }, {
    connected() {
      console.log("Connected to question channel " + question_id);
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.sid === data.sid) return;

      const answer = templateAnswer(data);
      answersList.append(answer);
    }
  });
});
