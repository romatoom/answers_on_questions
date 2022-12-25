const GistClient = require("gist-client");
const gistClient = new GistClient();

// Token for public
gistClient.setToken('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');

$(document).on('turbolinks:load', function(e) {
  $(".gist-content").each(function( index ) {
    const gistId = $(this).data("gistId")

    gistClient.getOneById(gistId)
    .then(response => {
      const [file] = Object.values(response.files);
      $(this).html(file.content);
    }).catch(err => {
      console.log(err)
    })
  });
});
