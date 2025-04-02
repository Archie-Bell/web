import API from "@/services/API.js";

export default {
    submitForm (form) {
        return API.post('/api/missing-persons/create/', form);
    },

    updateSubmission(data) {
        const token = localStorage.getItem('token');

        if (!token) {
            console.error('No valid token found in local storage.');
            return;
        }

        return API.post('/api/staff/submission/update/', data, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
    },

    updateFoundSubmission(data) {
        const token = localStorage.getItem('token');

        if (!token) {
            console.error('No valid token found in local storage.');
            return;
        }

        return API.post('/api/staff/missing-person/update/', data, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
    }
}