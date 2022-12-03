const SHOWING_TIME = 3000;
const FADE_OUT_TIME = 300;

ALERT_TYPES = {
  notice: 'secondary',
  alert: 'danger',
  success: 'success',
  warning: 'warning'
}

globalThis.alertCounter = 0;

const addAlert = (msg, type) => {
  alertType = ALERT_TYPES[type] || 'secondary';

  const alertId = "alert-" + globalThis.alertCounter;

  $('.alerts').append('<div id=' + alertId + ' class="alert alert-'+ alertType +'">' + msg + '</div>');

  setTimeout(function() {
    $("#" + alertId).fadeOut(FADE_OUT_TIME, function() {
      $(this).remove()
    });
  }, SHOWING_TIME);

  globalThis.alertCounter += 1;
}

window.addAlert = addAlert;

$(document).on('turbolinks:load', function() {
  $('.alert').each(function(i) {
    const alertId = "alert-" + globalThis.alertCounter;

    $(this).attr('id', alertId);
    globalThis.alertCounter += 1;

    setTimeout(function() {
      $("#" + alertId).fadeOut(FADE_OUT_TIME, function() {
        $(this).remove();
      });
    }, SHOWING_TIME);
  });
})
