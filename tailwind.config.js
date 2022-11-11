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
    './app/views/**/**',
    './app/views/**/**/*',
    './app/javascript/react_components/**/*.{jsx,tsx}',
  ],
  theme: {
    extend: {
      keyframes: {
        wiggle: {
          '0%, 100%': { transform: 'rotate(-3deg)' },
          '50%': { transform: 'rotate(3deg)' },
        },
      },
      animation: {
        wiggle: 'wiggle 1s ease-in-out infinite',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
    // require('@tailwindcss/aspect-ratio'),
  ],
};
