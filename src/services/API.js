import axios from "axios";

const API = axios.create({
    baseURL: import.meta.env.VITE_API_URL,
    headers: {
        'Access-Control-Allow-Origin': '*',
        'ngrok-skip-browser-warning': '3707'
    },
});

export default API;