const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    // Popper: ['popper.js', 'default'],
    // bootstrap: ['bootstrap']
    // $: 'jquery',
    // jQuery: 'jquery',
    // jquery: 'jquery',
    // 'window.Tether': 'tether',
    // Popper: ['popper.js', 'default'],
    // ActionCable: 'actioncable'
}))

environment.splitChunks();

module.exports = environment;
