$(document).on('turbolinks:load', function() {
  $('.questions').on('click', '.edit_question_btn', function(e) {
    e.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId');
    $('#edit-question-form-' + questionId).removeClass('d-none');
  })
})
