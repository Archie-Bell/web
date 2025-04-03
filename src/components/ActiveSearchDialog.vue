<template>
    <div class="modal-container" @click="handleClickOutside">
        <div class="modal p-5 rounded-2xl drop-shadow-xl min-w-[600px]" @click.stop>
            <h2 class="font-bold text-2xl">Review Submission</h2>
            <div class="grid grid-cols-3 gap-5 border-b">
                <div class="col-span-1">
                    <h4 class="font-bold">Provided Image</h4>
                </div>
                <div class="col-span-2">
                    <h4 class="font-bold">Submission Info</h4>
                </div>
            </div>
            <div class="grid grid-cols-3 gap-5 pt-2">
                <div class="col-span-1">
                    <img :src="image_url" alt="Fetched Data Image" v-if="image_url" />
                    <p v-else>Loading image...</p>
                </div>
                <div class="col-span-2">
                    <p><strong>Submission ID:</strong> {{ id }}</p>
                    <p><strong>Parent ID:</strong> {{ parent_id }}</p>
                    <p><strong>Found in:</strong> {{ location_found }}</p>
                    <p><strong>Found at:</strong> {{ datetime_found }}</p>
                    <p class="border-b"><strong>Provided information</strong></p>
                    <p class="break-all">{{ provided_info }}</p>
                </div>
            </div>
            
            <div class="mt-1">
                <label for="rejection_reason" class="font-bold">Reason (reject submission):</label><br/>
                <p v-if="update_error" class="pt-1 text-red-500 font-bold bg-red-300 bg-opacity-30 backdrop-blur-[30px] rounded-full px-3 my-2">{{ update_error }}</p>
                <textarea name="rejection_reason" v-model="rejection_reason" id="rejection_reason" class="w-full border rounded-xl p-2 mt-1 resize-none" rows="3" wrap="hard" maxlength="125" placeholder="Maximum 125 characters and minimum 20 characters allowed."></textarea>
            </div>


            <p v-if="action_confirm === 1" class="pt-3 text-center font-bold">{{ temp === 'approve' ? 'Are you sure you want to approve' : 'Are you sure you want to reject'}} this submission?</p>
            <div class="grid grid-cols-3 gap-5 content-center pt-5">
              <button @click="confirmAction('approve')" class="col-span-1 hover:bg-green-500 hover:bg-opacity-50">Approve</button>
              <button @click="confirmAction('reject')" class="col-span-1 hover:bg-red-500 hover:bg-opacity-50">Reject</button>
              <button @click="closeDialog" class="col-span-1">Cancel</button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import DataService from '@/services/DataService';
import FormService from '@/services/FormService';
import GetTimeSinceSubmission from '@/scripts/GetTimeSinceSubmission.js';

const image_url = ref(null);
const location_found = ref(null);
const datetime_found = ref(null);
const provided_info = ref(null);
const submission_status = ref(null);
const submission_date = ref(null);
const last_updated_date = ref(null);
const updated_by = ref(null);
const rejection_reason = ref(null);
const action_confirm = ref(0);
const temp = ref(null);

const update_error = ref(null);

const props = defineProps({
    id: String,
    parent_id: String,
});

const emit = defineEmits(["close"]);

const confirmAction = (btn) => {
    if (temp.value != btn) {
        action_confirm.value = 0;
    }

    if (btn === 'approve') {
        action_confirm.value += 1;
        temp.value = btn;
    }

    else if (btn === 'reject') {
        action_confirm.value += 1;
        temp.value = btn;
    }

    if (action_confirm.value === 2 && btn === 'approve') {
        console.log('Approve Button Triggered')
        updateFoundSubmission(btn);
    }
    
    if (action_confirm.value === 2 && btn === 'reject') {
        console.log('Reject Button Triggered')
        updateFoundSubmission(btn);
    }

    console.log(action_confirm.value);
}

const updateFoundSubmission = async (submission_status) => {
    try {
        if (submission_status === 'approve') {
            const data = {
                'submission_id': props.id,
                'parent_id': props.parent_id,
                'submission_status': 'approved',
            }

            await FormService.updateFoundSubmission(data);
            console.log('Successfully approved submission. All records about this person has been deleted.');
            closeDialog();
            location.reload();
        }

        if (submission_status === 'reject') {
            if (!rejection_reason.value || rejection_reason.value.trim().length === 0) {
                console.error('Rejection reason is required, and it can not be empty.');
                update_error.value = 'This field is required.';
                action_confirm.value = 0;
                return;
            }
            
            if (rejection_reason.value.trim().length < 20) {
                console.error('Rejection reason must be at least 20 characters.');
                update_error.value = `Rejection reason length is insufficient: ${rejection_reason.value.trim().length}`;
                action_confirm.value = 0;
                return;
            }
    
            const data = {
                'submission_id': props.id,
                'parent_id': props.parent_id,
                'reported_location': location_found.value,
                'reported_datetime': datetime_found.value,
                'reported_information': provided_info.value,
                'submission_status': 'rejected',
                'rejection_reason': rejection_reason.value,
                'submission_date': submission_date.value,
                'last_updated_date': last_updated_date.value
            }
    
            await FormService.updateFoundSubmission(data);
            console.log('Successfully rejected proposed found submission ID:', props.id);
            closeDialog();
        }
    }

    catch (e) {
        console.error('Something went wrong:', e);
        update_error.value('Something went wrong.');
        action_confirm.value = 0;
    }
};

const closeDialog = () => {
    emit("close");
};

// Function to handle clicks outside of the modal
const handleClickOutside = (event) => {
    // Close the modal only if the click is outside the modal content
    if (!event.target.closest(".modal")) {
        closeDialog();
    }
};

// Fetch the data based on the selected id
const fetchSelectedDataContents = async (parent_id, id) => {
    try {
        console.log('ID and Parent ID:', id, parent_id);
        const response = await DataService.fetchSingularFoundSubmissionData(parent_id, id);

        // Common fields for both pending and approved
        location_found.value = response.location_found;
        datetime_found.value = response.date_time_found;
        provided_info.value = response.provided_info;
        submission_status.value = response.submission_status;
        submission_date.value = GetTimeSinceSubmission.formatDateOfSubmission(response.submission_date);
        last_updated_date.value = GetTimeSinceSubmission.formatDateOfSubmission(response.last_updated_date);
        
        // Set the image URL (this part remains common)
        image_url.value = await fetchImageData(response.image_url, submission_status.value);
    } catch (e) {
        console.error('Failed to fetch specified data:', e);
    }
}

// Fetch image data from the API and return the URL
const fetchImageData = async (image, submission_status) => {
    if (submission_status.value !== 'Rejected') {
        try {
            const data = await DataService.fetchImageData(image);
            return data; // Assuming this returns a valid URL for the image
        } catch (e) {
            console.error('Error fetching image data:', e);
            return ''; // Return empty string or a fallback image in case of error
        }
    }

    else {
        console.log('Image fetching not required as rejected forms do not store images.')
        return '';
    }
}

onMounted(() => {
    fetchSelectedDataContents(props.parent_id, props.id);
});
</script>

<style scoped>
.modal-container {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0, 0, 0, 0.5); /* Optional background overlay */
    backdrop-filter: blur(5px);
    z-index: 999;
}

.grid {
    margin-top: auto; /* This will push the button to the bottom of the modal */
}
</style>

