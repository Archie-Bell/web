<template>
    <div class="modal-container" @click="handleClickOutside">
        <div class="modal p-5 rounded-2xl drop-shadow-xl content-center" @click.stop>
            <h2 class="font-bold text-2xl">Reject Submission?</h2>
            <div class="grid grid-cols-3 gap-1 pt-1">
                <div class="cols-span-1 content-center">
                    <img :src="image_url" alt="Fetched Data Image" v-if="image_url">
                    <p v-else>Loading image...</p>
                </div>
                
                <div class="ms-5 col-span-2">
                    <p><strong>Submission ID:</strong> {{ id }}</p>
                    <p><strong>Missing person:</strong> {{ name }}, {{ age }}</p>
                    <p><strong>Submitted by:</strong> {{ reporter_legal_name }}</p>
                    <p><strong>Submission date & time:</strong><br/> {{ submission_date }}</p>
                </div>
            </div>

            <div class="rounded-xl mt-1">
                <label for="rejection_reason" class="font-bold">Rejection reason:</label><br/>
                <p v-if="update_error" class="text-red-500 font-bold bg-red-300 bg-opacity-30 backdrop-blur-[30px] rounded-full px-3 my-2">{{ update_error }}</p>
                <textarea name="rejection_reason" v-model="rejection_reason" id="rejection_reason" class="w-full border rounded-xl p-2 mt-1 resize-none" rows="3" wrap="hard" maxlength="125" placeholder="Maximum 125 characters and minimum 20 characters allowed."></textarea>
            </div>

            <div class="grid grid-cols-2 gap-10 content-center pt-5">
              <button @click="rejectSubmission(props.id, rejection_reason)" class="hover:bg-red-500 hover:bg-opacity-50 col-span-1 transition-colors duration-200">Reject</button>
              <button @click="closeDialog" class="hover:bg-opacity-50 col-span-1 transition-colors duration-200">Cancel</button>
            </div>
        </div>
    </div>
</template>

<script setup>
import FormService from '@/services/FormService';
import { ref } from 'vue';
const rejection_reason = ref('');
const update_error = ref(null);

const emit = defineEmits(["close"]);

const closeDialog = () => {
    emit("close");
};

const rejectSubmission = async (id, rejection_reason) => {
    try {
        console.log('Attempting to reject submission:', id);
        
        if (!rejection_reason || rejection_reason.trim().length === 0) {
            console.error('Rejection reason is required, and it can not be empty.');
            update_error.value = 'This field is required.';
            return;
        }
        
        if (rejection_reason.trim().length < 20) {
            console.error('Rejection reason must be at least 20 characters.');
            update_error.value = `Rejection reason length is insufficient: ${rejection_reason.trim().length}`;
            return;
        }

        const data = {
            'submission_id': id,
            'status': 'Rejected',
            'rejection_reason': rejection_reason,
        }

        await FormService.updateSubmission(data);
        console.log('Submission successfully rejected:', id)
        closeDialog();
    }
    
    catch (e) {
        console.error('Something went wrong:', e);
    }
}

// Function to handle clicks outside of the modal
const handleClickOutside = (event) => {
    // Close the modal only if the click is outside the modal content
    if (!event.target.closest(".modal")) {
        closeDialog();
    }
};

const props = defineProps({
    id: String,
    name: String,
    age: Number,
    reporter_legal_name: String,
    submission_date: String,
    image_url: String,
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

