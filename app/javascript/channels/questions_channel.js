import consumer from "./consumer";
import channelExist from "./check_channel_exist";

const templateQuestion = require('../templates/question.hbs');

$(document).on('turbolinks:load', function() {
  const questionsList = $('.questions');
  const channel = "QuestionsChannel";

  if (channelExist(channel)) return;

  consumer.subscriptions.create(channel, {
    connected() {
      console.log('Connected to questions channel');
    },

    disconnected() {
    },

    received(data) {
      const question = templateQuestion(data);
      questionsList.append(question);
    }
  });

});
