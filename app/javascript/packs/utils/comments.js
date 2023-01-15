const templateComment = require('../../templates/comment.hbs');

$(document).on('turbolinks:load', function() {
  $('.container')
    .on('ajax:success', '.add_comment', handlerSuccess)
    .on('ajax:error', '.add_comment', handlerError)
});

function handlerSuccess(e) {
  const response = e.originalEvent.detail[0];
  $(this).find('.comment-body').val('');
  $(this).parents().children('.comments').append(templateComment(response));
  addAlert(response.message, 'success');
}

function handlerError(e) {
  const response = e.originalEvent.detail[0];
  addAlert(response.error, 'error');
};

