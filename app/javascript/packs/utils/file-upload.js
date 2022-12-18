$(document).on('turbolinks:load', setHandlerOnChangeQuestionFiles);

function setHandlerOnChangeQuestionFiles (e, resId = null) {
  if (resId !== null) {
    $("#question_files_" + resId).on('change', onChangeResource);
  } else {
    $(".question_files").on('change', onChangeResource);
  }

  function onChangeResource(e) {
    const resourceId = $(this).data('resourceId') || 0;

    const dt = new DataTransfer();

    for (let i = 0; i < this.files.length; i++) {
      let fileBloc = $('<span/>', { class: 'file-block' });
      let fileName = $('<span/>', { class: 'name', text: this.files.item(i).name });
      fileBloc.append("<span class='file-delete' data-resource-id='" + resourceId + "'><span>+</span></span>").append(fileName);

      if (resourceId > 0) {
        $("#edit-question-form-" + resourceId + " #filesList > #files-names").append(fileBloc);
      } else {
        $("#new-question-form #filesList > #files-names").append(fileBloc);
      }
    };

    for (let file of this.files) {
      dt.items.add(file);
    }

    this.files = dt.files;

    $('span.file-delete').on('click', function() {
      let name = $(this).next('span.name').text();

      for (let i = 0; i < dt.items.length; i++) {
        if (name === dt.items[i].getAsFile().name) {
          dt.items.remove(i);
          continue;
        }
      }

      const resourceId = $(this).data('resourceId') || 0;

      if (resourceId > 0) {
        document.getElementById('question_files_' + resourceId).files = dt.files;
      }

      $(this).parent().remove();
    });
  }
};

window.setHandlerOnChangeQuestionFiles = setHandlerOnChangeQuestionFiles;

