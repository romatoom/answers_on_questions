const templateVote = require('../../templates/vote.hbs');

$(document).on('turbolinks:load', function() {
  $('.vote')
    .on('ajax:success', '.like', function(e) {
      const response = e.originalEvent.detail[0]
      $(e.target).parent().html(templateVote(response));
      addAlert(response.message, 'success');
    })
    .on('ajax:error', '.like', function(e) {
      const response = e.originalEvent.detail[0]
      addAlert(response.error, 'error');
    })
    .on('ajax:success', '.dislike', function(e) {
      const response = e.originalEvent.detail[0]
      $(e.target).parent().html(templateVote(response));
      addAlert(response.message, 'success');
    })
    .on('ajax:error', '.dislike', function(e) {
      const response = e.originalEvent.detail[0]
      addAlert(response.error, 'error');
    })
    .on('ajax:success', '.reset-vote', function(e) {
      const response = e.originalEvent.detail[0]
      $(e.target).parent().html(templateVote(response));
    })
    .on('ajax:error', '.reset-vote', function(e) {
      const response = e.originalEvent.detail[0]
      addAlert(response.error, 'error');
    });
});
