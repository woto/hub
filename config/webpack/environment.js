const { environment } = require('@rails/webpacker')
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer')

const webpack = require('webpack')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'],
    bootstrap: ['bootstrap']
}))

environment.plugins.append(
  'BundleAnalyzer',
  new BundleAnalyzerPlugin()
)

module.exports = environment;
