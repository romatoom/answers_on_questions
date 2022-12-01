$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit_answer_btn', function(e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $('#edit-answer-form-' + answerId).removeClass('d-none');
  })
})
