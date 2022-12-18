$(document).on('turbolinks:load', function() {
  $('.questions').on('click', '.edit_question_btn', function(e) {
    e.preventDefault();
    $(this).hide();
    const resourceId = $(this).data('resourceId');
    $('#edit-question-form-' + resourceId).removeClass('d-none');
  });

  $('.questions').on('click', '.cancel-edit-question', function(e) {
    e.preventDefault();
    const resourceId = $(this).data('resourceId');
    $('#edit-question-form-' + resourceId).trigger("reset");
    $('#edit-question-form-' + resourceId + ' #filesList > #files-names').empty();
    $('#edit-question-form-' + resourceId + ' .file-list-for-delete').val('');
    $('#edit-question-form-' + resourceId).addClass('d-none');

    $('#question_' + resourceId + ' .edit_question_btn').show();
    $('#question_' + resourceId + ' .question-errors').html('');
    $('#question_' + resourceId + ' #question_title').removeClass('error');
    $('#question_' + resourceId + ' #question_body').removeClass('error');
  });

  $('.questions').on('click', '.add-file-to-list-for-delete', function(e) {
    $(this).parent().remove();
    const fileId = $(this).data('fileId');
    const resourceId = $(this).data('resourceId');

    const fileListInput = $('#edit-question-form-' + resourceId + ' .file-list-for-delete')

    const list_value = fileListInput.val();
    fileListInput.val(list_value + fileId + ',');
  });
});
