const path = require('path');
const webpack = require('webpack');
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';

module.exports = {
  module: {
    rules: [
      {
        test: /\.(js|jsx|ts|tsx|)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.(?:sa|sc|c)ss$/i,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
    ],
  },
  mode,
  devtool: 'source-map',
  entry: {
    application: './app/javascript/application.js',
    'swagger-ui': ['./app/javascript/swagger-ui.js', './app/assets/stylesheets/swagger-ui.css'],
  },
  output: {
    filename: '[name].js',
    sourceMapFilename: '[file].map',
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds'),
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.jsx', '.ts', '.tsx', '.css', '.sass', '.scss'],
  },
  plugins: [
    new MiniCssExtractPlugin(),
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1,
    }),
    ...mode === 'development' ? [new BundleAnalyzerPlugin()] : [],
  ],
  optimization: {
    // splitChunks: {
    //   cacheGroups: {
    //     vendor: {
    //       test: /[\\/]node_modules[\\/](react|react-dom)[\\/]/,
    //       name: 'vendor',
    //       chunks: 'all',
    //     },
    //   },
    // },
  },
};
