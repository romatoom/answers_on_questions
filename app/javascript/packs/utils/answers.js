$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit_answer_btn', function(e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $('#edit-answer-form-' + answerId).removeClass('d-none');
  });

  $('.answers').on('click', '.cancel-edit-answer', function(e) {
    e.preventDefault();
    const answerId = $(this).data('answerId');
    $('#edit-answer-form-' + answerId).trigger("reset");
    $('#edit-answer-form-' + answerId).addClass('d-none');

    $('#answer_' + answerId + ' .edit_answer_btn').show();
    $('#answer_' + answerId + ' .answer-errors').html('');
    $('#answer_' + answerId + ' #answer_body').removeClass('error');
  });
})
