import API from '@/services/API.js';

export default {
    async fetchPublicList() {
        try {
            const response = await API.get('/api/missing-persons');
            return response.data;
        }

        catch (e) {
            console.error('Unable to fetch missing persons list: ', e);
            throw error;
        }
    },

    async fetchSingularData() {
        try {
            const response = await API.get(`/api/missing-person/${id}/`)
            return response.data;
        }

        catch (e) {
            console.error('Unable to fetch missing persons list: ', e);
            throw e;
        }
    },
}