const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer')

process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

environment.plugins.append(
    'BundleAnalyzer',
    new BundleAnalyzerPlugin()
)

module.exports = environment.toWebpackConfig()
