import API from "@/services/API.js";

export default {
    submitForm (form) {
        return API.post('/api/submit', form);
    }
}