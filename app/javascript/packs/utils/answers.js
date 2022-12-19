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
    $('#editanswer-form-' + resourceId + ' #filesList > #files-names').empty();
    $('#edit-answer-form-' + resourceId + ' .file-list-for-delete').val('');
    $('#edit-answer-form-' + answerId).addClass('d-none');

    $('#answer_' + answerId + ' .edit_answer_btn').show();
    $('#answer_' + answerId + ' .answer-errors').html('');
    $('#answer_' + answerId + ' #answer_body').removeClass('error');
  });

  $('.answers').on('click', '.add-file-to-list-for-delete', function(e) {
    $(this).parent().remove();
    const fileId = $(this).data('fileId');
    const resourceId = $(this).data('resourceId');

    const fileListInput = $('#edit-answer-form-' + resourceId + ' .file-list-for-delete')

    const list_value = fileListInput.val();
    fileListInput.val(list_value + fileId + ',');
  });
})
