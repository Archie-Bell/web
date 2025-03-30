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
            throw new Error("Authentication verification failed");
        }
    },

    // Get user data by token
    async getUser(token) {
        try {
            const response = await API.get('/api/get/user', {
                headers: { 'Authorization': `Bearer ${token}` },
            });
            return response.data;
        } catch (err) {
            console.error("Failed to get user data:", err);
            throw new Error("Failed to fetch user");
        }
    },

    // Fetch user data from the server using stored token
    async fetchUserData() {
        try {
            const token = localStorage.getItem("token");
            if (!token) {
                throw new Error("Token not found in localStorage");
            }
            const response = await this.getUser(token);
            return response.decoded; // Return decoded user data
        } catch (err) {
            console.error("Error fetching user data:", err);
            return { error: err.message }; // Return error message if failed
        }
    }
};