const { environment, config } = require('@rails/webpacker')
const webpack = require('webpack')
const { resolve } = require('path')

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

environment.plugins.append('ContextReplacement',
    new webpack.ContextReplacementPlugin(
        /dayjs[/\\]locale$/,
        resolve(config.source_path)
    )
)

environment.splitChunks();

module.exports = environment;
