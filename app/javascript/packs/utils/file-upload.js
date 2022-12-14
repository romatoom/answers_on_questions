$(document).on('turbolinks:load', () => setHandlerOnChangeFiles(null, 'question'));
$(document).on('turbolinks:load', () => setHandlerOnChangeFiles(null, 'answer'));

function setHandlerOnChangeFiles (e, resType, resId = null) {
  if (resId !== null) {
    $("#" + resType + "_files_" + resId).on('change', onChangeResource);
  } else {
    $("." + resType + "_files").on('change', onChangeResource);
  }

  function onChangeResource(e) {
    const resourceId = $(this).data('resourceId') || 0;

    const dt = new DataTransfer();

    if (resourceId > 0) {
      $("#edit-" + resType + "-form-" + resourceId + " #filesList > #files-names").html('');
    } else {
      $("#new-" + resType + "-form #filesList > #files-names").html('');
    }

    for (let i = 0; i < this.files.length; i++) {
      let fileBloc = $('<span/>', { class: 'file-block' });
      let fileName = $('<span/>', { class: 'name', text: this.files.item(i).name });
      fileBloc.append("<span class='file-delete' data-resource-id='" + resourceId + "'><span>+</span></span>").append(fileName);

      if (resourceId > 0) {
        $("#edit-" + resType + "-form-" + resourceId + " #filesList > #files-names").append(fileBloc);
      } else {
        $("#new-" + resType + "-form #filesList > #files-names").append(fileBloc);
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
        document.getElementById(resType + '_files_' + resourceId).files = dt.files;
      } else {
        document.getElementById(resType + '_files').files = dt.files;
      }

      $(this).parent().remove();
    });
  }
};

window.setHandlerOnChangeFiles = setHandlerOnChangeFiles;

