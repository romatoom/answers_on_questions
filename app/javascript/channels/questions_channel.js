import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const templateQuestion = require('../templates/question.hbs');
  const questionsList = $('.questions')

  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log('Connected to questions_channel');
    },

    disconnected() {
    },

    received(data) {
      const question = templateQuestion(data);
      questionsList.append(question);
    }
  });
});
