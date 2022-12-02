$(document).on('turbolinks:load', function() {
  $('.questions').on('click', '.edit_question_btn', function(e) {
    e.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId');
    $('#edit-question-form-' + questionId).removeClass('d-none');
  });

  $('.questions').on('click', '.cancel-edit-question', function(e) {
    e.preventDefault();
    const questionId = $(this).data('questionId');
    $('#edit-question-form-' + questionId).trigger("reset");
    $('#edit-question-form-' + questionId).addClass('d-none');

    $('#question_' + questionId + ' .edit_question_btn').show();
    $('#question_' + questionId + ' .question-errors').html('');
    $('#question_' + questionId + ' #question_title').removeClass('error');
    $('#question_' + questionId + ' #question_body').removeClass('error');
  });
});
