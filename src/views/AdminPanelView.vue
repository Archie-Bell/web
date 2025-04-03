<template>
    <div class="p-10 flex h-screen items-center justify-center">
        <div class="w-full max-w-7xl">
            <!-- Header Section -->
            <header class="text-start mb-5">
                <h1 class="font-bold uppercase text-3xl">Admin Panel</h1>
                <div class="flex gap-3 justify-start mt-4">
                    <!-- Buttons to filter different submission statuses -->
                    <button @click="filterRequests('pending')" class="uppercase min-w-[10rem]">Pending</button>
                    <button @click="filterRequests('approved')" class="uppercase min-w-[10rem]">Approved</button>
                    <button @click="filterRequests('rejected')" class="uppercase min-w-[10rem]">Rejected</button>
                    <button @click="logout" class="uppercase hover:bg-red-500 hover:bg-opacity-50 ml-auto">Logout</button>
                </div>
            </header>

            <!-- Main Content Section -->
            <h2 class="text-xl font-bold border-b">
                {{ currentSubmissionPanel === 'pending' ? 'Pending Submissions' : currentSubmissionPanel === 'approved' ? 'Approved Submissions' : 'Rejected Submissions' }}
            </h2>
            <div class="flex mt-5 w-full h-[600px]">
                <!-- Left Panel -->
                <div class="pe-5 flex-[1] pt-3 overflow-y-auto flex flex-col border-r p-2 hide-scrollbar" style="max-height: 600px; flex-grow: 1">
                    <div class="" style="min-height: 558px; max-height: 558px;">
                        <!-- No items message -->
                        <div v-if="filteredList.length === 0" class="flex justify-center items-center text-center h-full">
                            No requests available.
                        </div>

                        <!-- Displaying filtered list of submissions -->
                        <div v-else class="flex flex-col">
                            <div v-for="(data, index) in filteredList" :key="index">
                                <FormRequestTile
                                    class="rounded-xl"
                                    :id="data._id"
                                    :name="data.name || data.reported_missing_person"
                                    :age="data.age"
                                    :reporter_legal_name="data.reporter_legal_name"
                                    :time_since_submission="GetTimeSinceSubmission.getTimeSinceSubmission(data.submission_date)"
                                    @click="passSelectedId(data._id, data.form_status)"
                                />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel -->
                <div class="ps-5 flex-[2]">
                    <RequestDetails :id="selectedId" :submission_type="requestType" :socketInstance="socketInstanceActiveSearch" />
                </div>
            </div>

            <!-- Active Searches Dialog -->
            <ActiveSearchesDialog v-if="isActiveSearchesDialogOpen" @close="closeActiveSearchesDialog" />

            <!-- Currently logged in as -->
            <h2 class="pt-1"><strong>Currently logged in as:</strong> {{ staff_email }}</h2>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import { useRouter } from "vue-router";
import FormRequestTile from "@/components/FormRequestTile.vue";
import RequestDetails from "@/components/RequestDetails.vue";
import ActiveSearchesDialog from "@/components/ActiveSearchDialog.vue";
import DataService from "@/services/DataService";
import GetTimeSinceSubmission from "@/scripts/GetTimeSinceSubmission.js";
import AuthService from "@/services/AuthService";

// State variables
const error = ref(null);
const isActiveSearchesDialogOpen = ref(false);
const pendingList = ref([]);
const approvedList = ref([]);
const rejectedList = ref([]);
const filteredList = ref([]); // List based on the selected filter
const selectedId = ref(null);
const requestType = ref('pending'); // The selected request type (pending, approved, rejected)
const currentSubmissionPanel = ref('pending');
const staff_email = ref(null);

// WebSocket state
const socketInstanceSubmission = ref(null); // WebSocket instance for submission updates
const socketInstanceActiveSearch = ref(null); // WebSocket instance for active search updates
const socketReconnectAttempts = ref(0);
let reconnectTimeout = 1000; // Initial reconnect delay

// Router instance
const router = useRouter();

// Emit function (for emitting events to parent)
const emit = defineEmits();

// Method to pass selected ID to the parent
const passSelectedId = (id, submission_type) => {
    requestType.value = submission_type.toLowerCase();
    selectedId.value = id;
};

// Fetch the list of requests (pending, approved, rejected)
const fetchRequests = async () => {
    try {
        pendingList.value = await DataService.fetchPendingList();
        approvedList.value = await DataService.fetchApprovedList();
        rejectedList.value = await DataService.fetchRejectedList();
        filterRequests(requestType.value);
    } catch (e) {
        error.value = "Failed to fetch list data.";
        console.error(error.value);
    }
};

// Filter requests based on the selected request type
const filterRequests = (type) => {
    currentSubmissionPanel.value = type;
    // requestType.value = type;
    console.log('Current Panel:', currentSubmissionPanel.value);
    if (type === 'pending') {
        filteredList.value = pendingList.value;
    } else if (type === 'approved') {
        filteredList.value = approvedList.value;
    } else if (type === 'rejected') {
        filteredList.value = rejectedList.value;
    }
};

// Logout functionality
const logout = () => {
    console.log("Logging out...");
    localStorage.removeItem('token');
    router.push("/");
};

// Fetch staff details after login
const fetchStaffDetails = async () => {
    const data = await AuthService.verifyAuthentication(localStorage.getItem('token'));
    staff_email.value = data.staff_email;
};

// WebSocket logic for Submission Updates
const handleSubmissionUpdates = (event) => {
    const data = JSON.parse(event.data);
    console.log('Submission WS:', data.message);
    if (data.type === 'update' && data.message !== null) {
        setTimeout(() => {
            console.log('Submission Update triggered');
            fetchRequests(requestType.value);
        }, 1000);
    }

    if (data.type === 'transaction' && data.message !== null) {
        selectedId.value = null;
        setTimeout(() => {
            fetchRequests(requestType.value);
        }, 1000);
    }
};

// WebSocket reconnection logic
const reconnectWebSocket = (socketType) => {
    if (socketReconnectAttempts.value < 5) {
        console.log(`Reconnecting to ${socketType} WebSocket... Attempt ${socketReconnectAttempts.value}`);
        const socketInstance = socketType === 'submission' ? socketInstanceSubmission : socketInstanceActiveSearch;
        socketInstance.value = new WebSocket(socketType === 'submission' ? 'ws://localhost:8000/ws/submission-updates/' : 'ws://localhost:8000/ws/active-search-updates/');
        socketReconnectAttempts.value++;

        reconnectTimeout *= 2;
        setTimeout(() => reconnectWebSocket(socketType), reconnectTimeout);
    } else {
        console.error(`Failed to reconnect to ${socketType} WebSocket after 5 attempts.`);
    }
};

onMounted(() => {
    // Fetch initial data right away
    fetchRequests(requestType.value);
    fetchStaffDetails();

    // Use setTimeout to delay the WebSocket connection and message handling
    setTimeout(() => {
        // WebSocket for submission updates
        socketInstanceSubmission.value = new WebSocket('ws://capable-namely-crane.ngrok-free.app/ws/submission-updates/');
        socketInstanceSubmission.value.onmessage = handleSubmissionUpdates;
        socketInstanceSubmission.value.onopen = () => {
            socketReconnectAttempts.value = 0;
            setInterval(() => sendHeartbeat('submission'), 30000);
        };
        socketInstanceSubmission.value.onclose = () => {
            reconnectWebSocket('submission');
        };
        socketInstanceSubmission.value.onerror = (error) => {
            console.error('Submission WebSocket error:', error);
            socketInstanceSubmission.value.close();
        };

        // WebSocket for active search updates
        socketInstanceActiveSearch.value = new WebSocket('ws://capable-namely-crane.ngrok-free.app/ws/active-search-updates/');
        socketInstanceActiveSearch.value.onopen = () => {
            socketReconnectAttempts.value = 0;
            setInterval(() => sendHeartbeat('active-search'), 30000);
        };
        socketInstanceActiveSearch.value.onclose = () => {
            reconnectWebSocket('active-search');
        };
        socketInstanceActiveSearch.value.onerror = (error) => {
            console.error('Active Search WebSocket error:', error);
            socketInstanceActiveSearch.value.close();
        };
    }, 1500); // Delay WebSocket connections by 1500ms
});


// Send heartbeat to keep both WebSocket connections alive
const sendHeartbeat = (socketType) => {
    const socketInstance = socketType === 'submission' ? socketInstanceSubmission : socketInstanceActiveSearch;
    if (socketInstance.value && socketInstance.value.readyState === WebSocket.OPEN) {
        console.log(`Sending heartbeat to ${socketType} WebSocket`);
        socketInstance.value.send(JSON.stringify({ type: 'ping' }));
    }
};

// Cleanup on component unmount
onBeforeUnmount(() => {
    if (socketInstanceSubmission.value) {
        socketInstanceSubmission.value.close();
    }
    if (socketInstanceActiveSearch.value) {
        socketInstanceActiveSearch.value.close();
    }
});
</script>

<style scoped>
/* Layout Styles */
.grid {
    display: grid;
    grid-template-rows: auto 1fr; /* Header and content */
}

header {
    padding-bottom: 20px;
}

.flex {
    display: flex;
    flex-grow: 1;
}

.pe-5 {
    padding-right: 1.25rem;
}

.ps-5 {
    padding-left: 1.25rem;
}

.flex-1 {
    flex: 1;
}

.flex-2 {
    flex: 2;
}

/* Ensure that content within the left panel scrolls properly */
.left-panel {
    overflow-y: auto;
    max-height: 600px; /* Adjust the max height as necessary */
}

/* Make sure that the content adjusts for smaller screens */
@media (max-width: 768px) {
    .flex {
        flex-direction: column; /* Stack the left and right panels vertically on smaller screens */
    }

    .pe-5 {
        padding-right: 0;
    }

    .ps-5 {
        padding-left: 0;
    }
}
</style>
