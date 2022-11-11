module.exports = {
  plugins: {
    'postcss-import': {},
    'tailwindcss/nesting': {},
    'tailwindcss': {},
    'postcss-nesting': {},
    'autoprefixer': {},
    'postcss-preset-env': {
      features: {'nesting-rules': false},
    },
  },
}
