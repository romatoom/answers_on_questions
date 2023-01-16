import consumer from "./consumer";
import channelExist from "./check_channel_exist";

$(document).on('turbolinks:load', function() {
  const question_id = gon.question_id;
  if (question_id) {
    const templateAnswer = require('../templates/answer.hbs');
    const answersList = $('.answers');
    const channel = "QuestionChannel";

    if (channelExist(channel, "question_id", question_id)) return;

    consumer.subscriptions.create({ channel: channel, question_id: question_id }, {
      connected() {
        console.log("Connected to question channel " + question_id);
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
  }
});


