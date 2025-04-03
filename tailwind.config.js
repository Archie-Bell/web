/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      backgroundImage: {
        'main': 'radial-gradient(circle at top left, #3D4DEE 10%, #293486 55%, #A0A5C0 90%, #D9D9D9 100%)',
      }
    },
  },
  plugins: [],
}

