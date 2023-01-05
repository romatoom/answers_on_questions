$(document).on('turbolinks:load', function() {
  $('.like')
    .on('ajax:success', function(e) {
      const response = e.originalEvent.detail[0]
      addAlert(response.message, 'success');
    })
    .on('ajax:error', function(e) {
      const response = e.originalEvent.detail[0]
      addAlert(response.error, 'error');
    })

   $('.dislike')
    .on('ajax:success', function(e) {
      const response = e.originalEvent.detail[0]
      addAlert(response.message, 'success');
    })
    .on('ajax:error', function(e) {
      const response = e.originalEvent.detail[0]
      addAlert(response.error, 'error');
    })
});
