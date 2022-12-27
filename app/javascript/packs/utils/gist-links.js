const GistClient = require("gist-client");
const gistClient = new GistClient();
const publicToken = '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';

// Safe token for public access
gistClient.setToken(publicToken);

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
