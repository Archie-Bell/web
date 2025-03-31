import API from '@/services/API.js';

export default {
    // Log in an existing user
    login(credentials) {
        return API.post('/api/staff/login/', credentials);
    },

    // Verify the user's authentication token
    async verifyAuthentication(token) {
        try {
            const response = await API.get('/api/staff/verify/', {
                headers: { 'Authorization': `Bearer ${token}` },
                timeout: 15000, // Set timeout to 15 seconds
            });
            return response.data;
        } catch (error) {
            console.error("Failed to verify authentication:", error);
            localStorage.removeItem('token');

            this.$router.push('/s/login')
            throw new Error("Authentication verification failed");
        }
    },
};