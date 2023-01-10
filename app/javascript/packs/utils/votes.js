const templateVote = require('../../templates/vote.hbs');
const templateVotesSum = require('../../templates/votes_sum.hbs');

$(document).on('turbolinks:load', function() {
  $('.vote-block')
    .on('ajax:success', '.like', handlerSuccess)
    .on('ajax:error', '.like', handlerError)
    .on('ajax:success', '.dislike', handlerSuccess)
    .on('ajax:error', '.dislike', handlerError)
    .on('ajax:success', '.reset-vote', handlerSuccess)
    .on('ajax:error', '.reset-vote', handlerError)
});


function handlerSuccess(e) {
  const response = e.originalEvent.detail[0];
  $(this).parent().html(templateVote(response));
  $($(e.delegateTarget).children('.votes-sum')[0]).html(templateVotesSum(response));
  addAlert(response.message, 'success')
}

function handlerError(e) {
  const response = e.originalEvent.detail[0];
  addAlert(response.error, 'error');
};
