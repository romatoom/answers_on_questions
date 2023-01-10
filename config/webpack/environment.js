const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

const handlebars = require('./loaders/handlebars')
environment.loaders.prepend('handlebars', handlebars)

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)

module.exports = environment
