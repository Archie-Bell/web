import axios from "axios";

const API = axios.create({
    baseURL: 'https://capable-namely-crane.ngrok-free.app/',
    headers: {
        'Access-Control-Allow-Origin': '*',
        'ngrok-skip-browser-warning': '59'
    },
});

export default API;