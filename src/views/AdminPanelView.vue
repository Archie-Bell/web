<template>
    <div class="p-10 flex h-screen items-center justify-center">
        <div class="w-full max-w-7xl">
            <!-- Header Section -->
            <header class="text-start mb-5">
                <h1 class="font-bold uppercase text-3xl">Admin Panel</h1>
                <div class="flex gap-1 justify-start mt-4">
                    <!-- Buttons to filter different submission statuses -->
                    <button @click="filterRequests('pending')" class="btn btn-blue uppercase">Pending</button>
                    <button @click="filterRequests('approved')" class="btn btn-blue uppercase">Approved</button>
                    <button @click="filterRequests('rejected')" class="btn btn-blue uppercase">Rejected</button>
                    <button @click="logout" class="btn btn-red uppercase">Logout</button>
                </div>
            </header>

            <!-- Main Content Section -->
            <h2 class="text-xl font-bold">
                {{ currentSubmissionPanel === 'pending' ? 'Pending Submissions' : currentSubmissionPanel === 'approved' ? 'Approved Submissions' : 'Rejected Submissions' }}
            </h2>
            <div class="flex mt-5 w-full h-[600px]">
                <!-- Left Panel -->
                <div class="pe-5 flex-[1] pt-3 overflow-y-auto flex flex-col rounded-xl border p-2" style="max-height: 600px; flex-grow: 1">
                    <div class="" style="min-height: 558px; max-height: 558px;">
                        <!-- No items message -->
                        <div v-if="filteredList.length === 0" class="flex justify-center items-center text-center text-gray-500 h-full">
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
                    <RequestDetails :id="selectedId" :submission_type="requestType" :socketInstance="socketInstance" />
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
import ActiveSearchesDialog from "@/components/ReviewFoundDialog.vue";
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
const socketInstance = ref(null);
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

// WebSocket logic to maintain connection
const sendHeartbeat = () => {
    if (socketInstance.value && socketInstance.value.readyState === WebSocket.OPEN) {
        console.log('Sending heartbeat to keep the connection alive');
        socketInstance.value.send(JSON.stringify({ type: 'ping' }));
    }
};

// WebSocket reconnection logic
const reconnectWebSocket = () => {
    if (socketReconnectAttempts.value < 5) {
        console.log(`Reconnecting to WebSocket... Attempt ${socketReconnectAttempts.value}`);
        socketInstance.value = new WebSocket('ws://localhost:8000/ws/submission-updates/');
        socketReconnectAttempts.value++;

        reconnectTimeout *= 2;
        setTimeout(reconnectWebSocket, reconnectTimeout);
    } else {
        console.error('Failed to reconnect to WebSocket after 5 attempts.');
    }
};

// WebSocket message handling
onMounted(() => {
    fetchRequests();
    fetchStaffDetails();

    socketInstance.value = new WebSocket('ws://localhost:8000/ws/submission-updates/');

    socketInstance.value.onmessage = (event) => {
        const data = JSON.parse(event.data);
        console.log('WS:', data.message);
        console.log('WS: Data Type:', data.type)
        if (data.type === 'update') {
            setTimeout(() => {
                console.log('Update triggered')
                fetchRequests();
            }, 1000);
        }

        if (data.type === 'transaction') {
            selectedId.value = null;
            setTimeout(() => {
                fetchRequests();
            }, 1000);
        }
    };

    socketInstance.value.onopen = () => {
        socketReconnectAttempts.value = 0;
        setInterval(sendHeartbeat, 30000);
    };

    socketInstance.value.onclose = () => {
        reconnectWebSocket();
    };

    socketInstance.value.onerror = (error) => {
        console.error('WebSocket error:', error);
        socketInstance.value.close();
    };
});

// Cleanup on component unmount
onBeforeUnmount(() => {
    if (socketInstance.value) {
        socketInstance.value.close();
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