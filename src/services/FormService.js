import API from "@/services/API.js";

export default {
    submitForm (form) {
        console.log(form)
        return API.post('/api/missing-persons/create/', form);
    }
}