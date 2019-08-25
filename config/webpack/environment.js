const { environment } = require('@rails/webpacker')

// less-loader used at least for landing page
environment.loaders.append
('less-loader',
      {
        test: /\.less$/,
        use: [{
            loader: "style-loader"
        }, {
            loader: "css-loader"
        }, {
            loader: "less-loader",
            options: {
                javascriptEnabled: true
            }
        }]
      },
)

module.exports = environment
