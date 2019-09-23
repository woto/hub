const { environment } = require('@rails/webpacker');

// less-loader used at least for landing page
environment.loaders.append('less-loader',
  {
    test: /\.less$/,
    use: [{
      loader: 'style-loader',
    }, {
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
