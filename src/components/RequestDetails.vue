<template>
    <div class="pt-3">
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
        
        <div class="border rounded-xl p-2" style="min-height: 493px; height: 40vh">
            <div v-if="!idRef" class="flex items-center justify-center h-full text-gray-500">
                <p>Select a form to view its details.</p>
            </div>
    
            <div v-else>
                <!-- Overview Tab -->
                <div v-if="current_tab === 0">
                    <div class="grid grid-cols-3 gap-6">
                        <div v-if="form_status === 'Pending' || form_status === 'Approved'" class="p-4 border rounded-xl content-center">
                            <!-- Using the ref for the image URL directly -->
                            <img :src="image_url" alt="Fetched Data Image" v-if="image_url" />
                            <p v-else>Loading image...</p>
                        </div>

                        <!-- Conditionally apply col-span based on form_status -->
                        <div :class="form_status === 'Rejected' ? 'p-4 col-span-3 border rounded-xl min-h-[29.7rem] max-h-[29.7rem] flex flex-col justify-between' : 'p-4 col-span-2 border rounded-xl min-h-[29.7rem] max-h-[29.7rem] flex flex-col justify-between'">
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
                    <div class="p-2 mt-2 border rounded-xl min-h-[17.1rem]">
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
        </div>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import TabBar from "./TabBar.vue";
import DataService from '@/services/DataService.js';
import GetTimeSinceSubmission from '@/scripts/GetTimeSinceSubmission.js';
import ApproveDialog from './ApproveDialog.vue';
import RejectDialog from './RejectDialog.vue';

// Initialize refs to store data
const idRef = ref('');
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

const image_url = ref(''); // Ref to store the image URL

// Use defineProps to get the id from the parent component
const props = defineProps({
    id: String,
    submission_type: String,
});

// Update the idRef whenever the id prop changes
watch(() => props.id, (newId) => {
    idRef.value = newId;
    fetchSelectedDataContents(idRef.value, props.submission_type);
    current_tab.value = 0;
});

// Handle tab selection
const current_tab = ref(0);
const tabSelectHandler = (val) => {
    current_tab.value = val;
}

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
const previous_tab = ref(null);

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
</script>