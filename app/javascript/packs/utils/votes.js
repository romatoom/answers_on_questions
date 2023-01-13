const templateVote = require('../../templates/vote.hbs');

$(document).on('turbolinks:load', function() {
  $('.container')
    .on('ajax:success', '.like', handlerSuccess)
    .on('ajax:error', '.like', handlerError)
    .on('ajax:success', '.dislike', handlerSuccess)
    .on('ajax:error', '.dislike', handlerError)
    .on('ajax:success', '.reset-vote', handlerSuccess)
    .on('ajax:error', '.reset-vote', handlerError)
});

function handlerSuccess(e) {
  const response = e.originalEvent.detail[0];
  $(this).parents('.vote-block').html(templateVote(response));
  addAlert(response.message, 'success');
}

function handlerError(e) {
  const response = e.originalEvent.detail[0];
  addAlert(response.error, 'error');
};
