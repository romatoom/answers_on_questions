const templateVote = require('../../templates/vote.hbs');
const templateVotesSum = require('../../templates/votes_sum.hbs');

$(document).on('turbolinks:load', function() {
  $('.vote-block')
    .on('ajax:success', '.like', handlerSuccess)
    .on('ajax:error', '.like', function(e) {
      const response = e.originalEvent.detail[0];
      addAlert(response.error, 'error');
    })
    .on('ajax:success', '.dislike', handlerSuccess)
    .on('ajax:error', '.dislike', function(e) {
      const response = e.originalEvent.detail[0];
      addAlert(response.error, 'error');
    })
    .on('ajax:success', '.reset-vote', handlerSuccess);
});


function handlerSuccess(e) {
  const response = e.originalEvent.detail[0];
  $(this).parent().html(templateVote(response));
  $($(e.delegateTarget).children('.votes-sum')[0]).html(templateVotesSum(response));
  addAlert(response.message, 'success')
}
