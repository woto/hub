const { environment, config } = require('@rails/webpacker');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const dotenv = require('dotenv');
const webpack = require('webpack');

const dotenvFiles = [
  `.env.${process.env.HUB_ENV}`,
  '.env',
];

dotenvFiles.forEach((dotenvFile) => {
  dotenv.config({ path: dotenvFile, silent: true });
});

environment.plugins.prepend('Environment', new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env))));

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
