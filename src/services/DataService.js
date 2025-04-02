import API from '@/services/API.js';

export default {
    async fetchPendingList() {
        try {
            const token = localStorage.getItem('token');

            if (!token) {
                console.error('No valid token found in local storage.');
                return;
            }

            const response = await API.get('/api/missing-persons/pending', {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            
            return response.data;
        }

        catch (e) {
            console.error('Unable to fetch pending list: ', e);
            throw error;
        }
    },

    async fetchApprovedList() {
        try {
            const response = await API.get('/api/missing-persons/')
            
            return response.data;
        }

        catch (e) {
            console.error('Unable to fetch missing persons list: ', e);
            throw error;
        }
    },

    async fetchRejectedList() {
        try {
            const token = localStorage.getItem('token');

            if (!token) {
                console.error('No valid token found in local storage.');
                return;
            }

            const response = await API.get('/api/missing-persons/rejected', {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            
            return response.data;
        }

        catch (e) {
            console.error('Unable to fetch rejected list: ', e);
            throw error;
        }
    },

    async fetchSingularData(id, submission_type) {
        try {
            const token = localStorage.getItem('token');
    
            if (id === null) {
                console.error('Returning as there\'s no submission ID specified.');
                return {
                    error: 'Returning as there\'s no submission ID specified.'
                };
            }
    
            const validStatuses = ['pending', 'approved', 'rejected'];
            if (!validStatuses.includes(submission_type)) {
                console.error('Invalid submission type provided.');
                return {
                    error: 'Invalid submission type provided.'
                };
            }
    
            let endpoint = '';
            
            switch (submission_type) {
                case 'pending':
                    endpoint = `/api/missing-person/pending/${id}/`;
                    break;
                case 'approved':
                    endpoint = `/api/missing-person/${id}/`;
                    break;
                case 'rejected':
                    endpoint = `/api/missing-person/rejected/${id}/`;
                    break;
                default:
                    console.error('Invalid status.');
                    return {
                        error: 'Invalid status provided.'
                    };
            }
    
            const response = await API.get(endpoint, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
    
            return response.data;
        } catch (e) {
            console.error('Unable to fetch missing person data:', e);
            throw e;
        }
    },

    async fetchSingularFoundSubmissionData(parent_id, submission_id) {
        const token = localStorage.getItem('token');
    
        if (submission_id === null) {
            console.error('Returning as there\'s no submission ID specified.');
            return {
                error: 'Returning as there\'s no submission ID specified.'
            };
        }

        if (parent_id === null) {
            console.error('Returning as there\'s no submission ID specified.');
            return {
                error: 'Returning as there\'s no parent ID specified.'
            };
        }
    
        const response = await API.get(`/api/staff/missing-person/submissions/${parent_id}/${submission_id}`, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
        return response.data;
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
            console.error('Unable to fetch or display image.');
        }
    },

    async fetchActiveSearchSubmissions(id) {
        try {
            const token = localStorage.getItem('token');
            const response = await API.get(`/api/staff/missing-person/submissions/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            return response.data;
        } catch (e) {
            console.error('Unable to fetch found submissions data:', e);
        }
    },

    async fetchRejectedActiveSearchSubmissions(id) {
        try {
            const token = localStorage.getItem('token');
            const response = await API.get(`/api/staff/missing-person/submissions/rejected/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            return response.data;
        } catch (e) {
            console.error('Unable to fetch rejected found submissions data:', e);
        }
    },

    async deleteSpecificRejectedFoundSubmission(id) {
        try {
            const token = localStorage.getItem('token');
            const response = await API.delete(`/api/staff/missing-person/submissions/rejected/purge/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            return response.data;
        } catch (e) {
            console.error('Unable to delete rejected found submissions data:', e);
        }
    },
}