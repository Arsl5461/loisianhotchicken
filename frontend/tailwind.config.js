/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      colors: {
        brand: {
          red: '#A6190F',
          deep: '#B71C12',
          yellow: '#FFD500',
          amber: '#FFC107',
          orange: '#FF6B00',
        },
        ink: {
          900: '#1E1E1E',
          800: '#252525',
        },
      },
      boxShadow: {
        card: '0 10px 30px -18px rgba(30, 30, 30, 0.35)',
      },
    },
  },
  plugins: [],
};
