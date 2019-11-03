const { environment, config } = require('@rails/webpacker');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

environment.loaders.append('less-loader',
  {
    test: /\.less$/,
    use: [{
      loader: config.extract_css ? MiniCssExtractPlugin.loader : 'style-loader',
    },
    {
      loader: 'css-loader',
      options: {
        sourceMap: true,
      },
    }, {
      loader: 'less-loader',
      options: {
        javascriptEnabled: true,
        sourceMap: true,
      },
    }],
  });

module.exports = environment;
