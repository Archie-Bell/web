<template>
    <div>
        <h2 class="font-bold uppercase text-2xl">{{ idRef ? `${name} - Information Screen` : 'No Person Selected' }}</h2>

        <!-- TabBar component with event listener for opening the approve modal -->
        <TabBar 
            @selected-tab="tabSelectHandler" 
            @open-approve-dialog="openApproveDialog" 
            @open-reject-dialog="openRejectDialog" 
            class="pb-5"
            :disabled="!idRef"
            :form-status="submission_type"
        />
        
        <div class="border rounded-xl p-2" style="min-height: 507px; height: 40vh">
            <div v-if="!idRef" class="flex items-center justify-center h-full text-gray-500">
                <p>Select a form to view its details.</p>
            </div>
    
            <div v-else>
                <!-- Overview Tab -->
                <div v-if="current_tab === 0">
                    <div class="grid grid-cols-3 gap-6">
                        <div v-if="form_status === 'Pending' || form_status === 'Approved'" class="p-4 border rounded-xl content-center">
                            <!-- Using the ref for the image URL directly -->
                            <img :src="image_url" class="rounded-xl" alt="Fetched Data Image" v-if="image_url" />
                            <p v-else>Loading image...</p>
                        </div>

                        <!-- Conditionally apply col-span based on form_status -->
                        <div :class="form_status === 'Rejected' ? 'p-4 col-span-3 border rounded-xl min-h-[30.6rem] max-h-[30.6rem] flex flex-col justify-between' : 'p-4 col-span-2 border rounded-xl min-h-[30.6rem] max-h-[30.6rem] flex flex-col justify-between'">
                            <p class="text-lg"><strong>{{ form_status !== 'Rejected' ? 'Name' : 'Reported missing person' }}:</strong> {{ name }}</p>
                            <p class="text-lg" v-if="form_status !== 'Rejected'"><strong>Age:</strong> {{ age }}</p>
                            <p class="text-lg"><strong>{{ form_status !== 'Rejected' ? 'Last known location' : 'Reported missing location' }}:</strong> {{ last_location_seen }}</p>
                            <p class="text-lg"><strong>{{ form_status !== 'Rejected' ? 'Last date/time seen' : 'Reported date/time missing' }}:</strong> {{ last_location_seen }}</p>
                            <p class="text-lg"><strong>Submitted at:</strong> {{ submission_date }}</p>
                            <p class="text-lg"><strong>Last updated at:</strong> {{ last_updated_date }}</p>
                            <p class="text-lg"><strong>Submission status:</strong> {{ form_status }}</p>
                            <p class="text-lg" v-if="form_status !== 'Rejected'"><strong>Additional info:</strong></p>
                            <p class="text-lg" v-else><strong>Rejection reason:</strong></p>
                            <p class="break-all" v-if="form_status !== 'Rejected'">{{ additional_info }}</p>
                            <p class="break-all" v-else>{{ rejection_reason }}</p>
                            <p class="text-lg" v-if="form_status !== 'Pending'"><strong>Updated by:</strong> {{ updated_by }}</p>
                        </div>
                    </div>
                </div>
    
                <!-- Contact Tab -->
                <div v-else-if="current_tab === 1">
                    <div class="p-2 border rounded-xl min-h-[12.1rem]">
                        <p class="text-lg p-2 mb-2 border rounded-xl drop-shadow"><strong>Missing Person Details</strong></p>
                        <p class="text-m">- <strong>{{ form_status !== 'Rejected' ? 'Name & age' : 'Reported missing person'}}:</strong> {{ form_status !== 'Rejected' ? `${name}, ${age}` : name }}</p>
                        <p class="text-m">- <strong>{{ form_status !== 'Rejected' ? 'Last location & date' : 'Reported missing location'}}:</strong> {{ form_status !== 'Rejected' ? `${last_location_seen} (${last_date_time_seen})` : last_location_seen }}</p>
                        <p class="text-m" v-if="form_status === 'Rejected'">- <strong>Reported date/time missing:</strong> {{ last_date_time_seen }}</p>
                        <p class="text-m" v-if="form_status !== 'Rejected'">- <strong>Additional provided information:</strong></p>
                        <p v-if="form_status === 'Rejected' ">- <strong>Last updated date:</strong> {{ last_updated_date }}</p>
                        <p class="text-m break-all">{{ additional_info }}</p>
                    </div>
                    <div class="p-2 mt-2 border rounded-xl min-h-[18rem]">
                        <p class="text-lg p-2 mb-2 border rounded-xl drop-shadow"><strong>Reporter Information</strong></p>
                        <p class="text-m">- <strong>Reporter's legal name:</strong> {{ reporter_legal_name }}</p>
                        <p class="text-m">- <strong>Reporter's phone number:</strong> {{ reporter_phone_number }}</p>
                        <p class="text-m">- <strong>Reporter's location:</strong> {{ last_location_seen }}</p>
                        <p class="text-m">- <strong>Reporter's submission date:</strong> {{ submission_date }}</p>
                        <p class="text-m">- <strong>Submission status:</strong> {{ form_status }}</p>
                        <p v-if="form_status === 'Rejected'" class="text-m break-all">- <strong>Rejection reason:</strong><br/>{{ rejection_reason }}</p>
                        <p v-if="form_status !== 'Pending'">- <strong>Updated by:</strong> {{ updated_by }}</p>
                        <p v-if="form_status === 'Approved' ">- <strong>Last updated date:</strong> {{ last_updated_date }}</p>
                    </div>
                </div>

                <div v-else-if="current_tab === 2">
                    <h2 class="text-lg font-bold border-b">Found Person Submissions</h2>
                    <span>
                        <button class="btn btn-blue mt-1" @click="fetchPendingActiveSearchSubmissions(idRef, 0)">Pending</button>
                        <button class="btn btn-blue mt-1 ms-1" @click="fetchPendingActiveSearchSubmissions(idRef, 1)">Rejected</button>
                    </span>
                    <div class="flex-[1] p-2 mt-2 border rounded-xl min-h-[25.5rem] max-h-[25.5rem] overflow-y-auto">
                        <!-- No items message -->
                        <div v-if="foundSubmissionList.length === 0" class="flex justify-center items-center text-center text-gray-500 h-full">
                            No requests available.
                        </div>

                        <!-- Displaying filtered list of submissions -->
                        <div v-else class="flex flex-col">
                            <div v-for="(data, index) in foundSubmissionList" :key="index">
                                <FoundSubmissionTile
                                    class="rounded-xl"
                                    :index="index + 1"
                                    :id="data._id"
                                    :submission_status="data.submission_status"
                                    :time_since_submission="GetTimeSinceSubmission.getTimeSinceSubmission(data.last_updated_date)"
                                    :rejection_reason="data.rejection_reason"
                                    @open-review-dialog="openReviewDialog($event)"
                                />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
    
            <!-- Method to open Approve screen -->
            <Teleport to="body">
                <!-- The modal will only be shown if the flag isApproveDialogOpen is true -->
                <ApproveDialog 
                    v-if="is_approve_dialog_open" 
                    :id="idRef" 
                    :name="name" 
                    :age="age" 
                    :reporter_legal_name="reporter_legal_name" 
                    :submission_date="submission_date"
                    :image_url="image_url"
                    @close="closeApproveDialog" 
                />
            </Teleport>

            <!-- Method to open Approve screen -->
            <Teleport to="body">
                <!-- The modal will only be shown if the flag isApproveDialogOpen is true -->
                <RejectDialog 
                    v-if="is_reject_dialog_open" 
                    :id="idRef" 
                    :name="name" 
                    :age="age" 
                    :reporter_legal_name="reporter_legal_name" 
                    :submission_date="submission_date"
                    :image_url="image_url"
                    @close="closeRejectDialog" 
                />
            </Teleport>

            <Teleport to="body">
                <ReviewFoundDialog
                    v-if="is_review_dialog_open"
                    @close="closeReviewDialog"
                    :id="submission_id"
                    :parent_id="parent_id"
                >
                </ReviewFoundDialog>
            </Teleport>
        </div>
    </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import TabBar from "./TabBar.vue";
import DataService from '@/services/DataService.js';
import GetTimeSinceSubmission from '@/scripts/GetTimeSinceSubmission.js';
import ApproveDialog from './ApproveDialog.vue';
import RejectDialog from './RejectDialog.vue';
import FoundSubmissionTile from './FoundSubmissionTile.vue';
import ReviewFoundDialog from './ReviewFoundDialog.vue';

// Initialize refs to store data
const idRef = ref(null);
const name = ref('');
const age = ref(0);
const last_location_seen = ref('');
const last_date_time_seen = ref('');
const additional_info = ref('');
const submission_date = ref('');
const last_updated_date = ref('');
const reporter_legal_name = ref('');
const reporter_phone_number = ref('');
const form_status = ref('');
const rejection_reason = ref('');
const updated_by = ref('');
const foundSubmissionList = ref([]);

const image_url = ref(''); // Ref to store the image URL

const socketInstanceActiveSearch = ref(null);

// Use defineProps to get the id from the parent component
const props = defineProps({
    id: String,
    submission_type: String,
    socketInstance: WebSocket,
});

// Update the idRef whenever the id prop changes
watch(() => props.id, (newId) => {
    idRef.value = newId;
    fetchSelectedDataContents(idRef.value, props.submission_type);
    current_tab.value = 0;
});

// Handle tab selection
const current_found_person_tab = ref(null);
const current_tab = ref(0);
const tabSelectHandler = (val) => {
    current_tab.value = val;
}

watch(() => current_tab.value, (newTab) => {
    if (newTab === 2 && idRef.value) {
        fetchPendingActiveSearchSubmissions(idRef.value, 0);
    }
});

// Fetch the data based on the selected id
const fetchSelectedDataContents = async (id, submission_type) => {
    try {
        const response = await DataService.fetchSingularData(id, submission_type);

        // Common fields for both pending and approved
        if (submission_type !== 'rejected') {
            name.value = response.name;
            age.value = response.age;
            last_location_seen.value = response.last_location_seen;
            last_date_time_seen.value = response.last_date_time_seen;
            additional_info.value = response.additional_info;
            submission_date.value = GetTimeSinceSubmission.formatDateOfSubmission(response.submission_date);
            last_updated_date.value = GetTimeSinceSubmission.formatDateOfSubmission(response.last_updated_date);
            reporter_legal_name.value = response.reporter_legal_name;
            reporter_phone_number.value = response.reporter_phone_number;
            form_status.value = response.form_status;

            if (submission_type === 'approved') {
                updated_by.value = response.updated_by; // Correct assignment
            }
        } else {
            // For rejected submission type, map fields accordingly
            name.value = response.reported_missing_person; // Ensure this property exists in the response
            age.value = null; // Age is not available in rejected submissions
            last_location_seen.value = response.reported_missing_location;
            last_date_time_seen.value = response.reported_date_time_missing;
            additional_info.value = ''; // You can map additional info if available
            submission_date.value = GetTimeSinceSubmission.formatDateOfSubmission(response.submission_date);
            last_updated_date.value = GetTimeSinceSubmission.formatDateOfSubmission(response.last_updated_date);
            reporter_legal_name.value = response.reporter_legal_name;
            reporter_phone_number.value = response.reporter_phone_number;
            form_status.value = response.form_status || "Pending"; // Default value for form status
            rejection_reason.value = response.rejection_reason || "No reason provided";
            updated_by.value = response.updated_by; // Correct assignment
        }

        // Set the image URL (this part remains common)
        image_url.value = await fetchImageData(response.image_url, form_status.value);
    } catch (e) {
        console.error('Failed to fetch specified data:', e);
    }
}

// Fetch image data from the API and return the URL
const fetchImageData = async (image, form_status) => {
    if (form_status !== 'Rejected') {
        try {
            const data = await DataService.fetchImageData(image);
            return data; // Assuming this returns a valid URL for the image
        } catch (e) {
            console.error('Error fetching image data:', e);
            return ''; // Return empty string or a fallback image in case of error
        }
    }

    else {
        console.log('Image fetching not required as Rejected forms do not store images.')
        return '';
    }
}

// Modal control
const is_approve_dialog_open = ref(false);
const is_reject_dialog_open = ref(false);
const is_review_dialog_open = ref(false);
const submission_id = ref(null);
const parent_id = ref(null);
const previous_tab = ref(null);


const openReviewDialog = (id) => {
    is_review_dialog_open.value = true;
    submission_id.value = id;
    parent_id.value = idRef.value;
};

const closeReviewDialog = () => {
    is_review_dialog_open.value = false;
};

// Open ApproveDialog
const openApproveDialog = () => {
    console.log("Opening Approve Dialog");
    if (idRef.value) {
        previous_tab.value = current_tab.value;
        is_approve_dialog_open.value = true; // Open the modal
    }
};

// Close ApproveDialog
const closeApproveDialog = () => {
    is_approve_dialog_open.value = false; // Close the modal
    current_tab.value = previous_tab.value; // Restore the previous tab
};

// Open RejectDialog
const openRejectDialog = () => {
    console.log("Opening Reject Dialog");
    if (idRef.value) {
        previous_tab.value = current_tab.value;
        is_reject_dialog_open.value = true; // Open the modal
    }
};

// Close RejectDialog
const closeRejectDialog = () => {
    is_reject_dialog_open.value = false; // Close the modal
    current_tab.value = previous_tab.value; // Restore the previous tab
};

const fetchPendingActiveSearchSubmissions = async (id, val) => {
    try {
        console.log('Fetching found submissions')
        console.log('ID:', id)

        current_found_person_tab.value = val;

        if (current_found_person_tab.value === 0) {
            const response = await DataService.fetchActiveSearchSubmissions(id);
            foundSubmissionList.value = response;
            return;
        }

        if (current_found_person_tab.value === 1) {
            const response = await DataService.fetchRejectedActiveSearchSubmissions(id);
            foundSubmissionList.value = response;
            return;
        }
        console.log(foundSubmissionList.value);
    } catch (e) {
        console.error('Unable to fetch found submission data:', e)
    }
}

// WebSocket logic for Active Search Updates
const handleActiveSearchUpdates = (event) => {
    const data = JSON.parse(event.data);
    console.log('Active Search WS:', data.message);
    if (data.type === 'active_search_update') {
        if (current_found_person_tab.value === 0 || current_found_person_tab.value === 1) {
            if (idRef.value !== null) fetchPendingActiveSearchSubmissions(idRef.value, current_found_person_tab.value)
        }
    }
};

onMounted(() => {
    socketInstanceActiveSearch.value = new WebSocket('ws://localhost:8000/ws/active-search-updates/');
    socketInstanceActiveSearch.value.onmessage = handleActiveSearchUpdates;

    if (current_found_person_tab.value === 0 || current_found_person_tab.value === 1) {
            if (idRef.value !== null) fetchPendingActiveSearchSubmissions(idRef.value, current_found_person_tab.value)
    }
})
</script>