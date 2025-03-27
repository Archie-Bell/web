import API from "@/services/API.js";

export default {
    submitForm (form) {
        return API.post('/api/missing-persons/create/', form);
    }
}