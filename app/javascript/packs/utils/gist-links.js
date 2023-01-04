const GistClient = require("gist-client");
const gistClient = new GistClient();
const publicToken = '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';
// Safe token for public access

$(document).on('turbolinks:load', function(e) {
  gistClient.setToken(publicToken);

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

  gistClient.unsetToken()
});
