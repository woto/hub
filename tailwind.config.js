/** @type {import('tailwindcss').Config} */
module.exports = {
  prefix: 'tw-',
  content: [
    './app/helpers/**/*.rb',
    './app/components/**/*.{rb,erb}',
    './app/decorators/**/*.rb',
    './app/javascript/**/*.js',
    './app/javascript/**/*.js',
    './app/views/**/*',
    './app/javascript/react_components/**/*.{jsx,tsx}'
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
  ],
}
