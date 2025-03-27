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

    async fetchSingularData(id) {
        try {
            const response = await API.get(`/api/missing-person/${id}/`)
            return response.data;
        }

        catch (e) {
            console.error('Unable to fetch missing persons list: ', e);
            throw e;
        }
    },

    async fetchImageData(val) {
        try {
            const response = await API.get(`${val}/`, {
                responseType: 'arraybuffer'  // Handle binary data correctly
            });
            // Convert binary data into a URL
            const blob = new Blob([response.data], { type: 'image/jpeg' });  // Change MIME type based on your image type
            const imageUrl = URL.createObjectURL(blob);  // Create a URL for the image
            return imageUrl;
        } catch (e) {
            console.error('Unable to fetch or display image: ', e);
            throw e;
        }
    },
}