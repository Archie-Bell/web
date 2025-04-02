<template>
    <div class="modal-container" @click="handleClickOutside">
        <div class="modal p-5 rounded-2xl drop-shadow-xl content-center" @click.stop>
            <h2 class="font-bold text-2xl">Reject Submission?</h2>
            <div class="grid grid-cols-3 gap-1 pt-1">
                <div class="p-2 border rounded-xl cols-span-1 content-center">
                    <img :src="image_url" class="rounded-xl" alt="Fetched Data Image" v-if="image_url">
                    <p v-else>Loading image...</p>
                </div>
                
                <div class="p-2 border rounded-xl col-span-2">
                    <p><strong>Submission ID:</strong> {{ id }}</p>
                    <p><strong>Missing person:</strong> {{ name }}, {{ age }}</p>
                    <p><strong>Submitted by:</strong> {{ reporter_legal_name }}</p>
                    <p><strong>Submission date & time:</strong><br/> {{ submission_date }}</p>
                </div>
            </div>

            <div class="p-2 border rounded-xl mt-1">
                <label for="rejection_reason" class="font-bold">Rejection reason:</label><br/>
                <textarea name="rejection_reason" v-model="rejection_reason" id="rejection_reason" class="w-full border rounded-xl p-2 mt-1 resize-none" rows="3" wrap="hard" maxlength="125" placeholder="Maximum 125 characters and minimum 20 characters allowed."></textarea>
            </div>

            <p v-if="update_error" class="pt-1 text-red-600">{{ update_error }}</p>

            <div class="grid grid-cols-2 gap-1 content-center pt-1">
              <button @click="rejectSubmission(props.id, rejection_reason)" class="btn btn-red col-span-1">Reject</button>
              <button @click="closeDialog" class="btn btn-green col-span-1">Cancel</button>
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
    z-index: 999;
}

.modal {
    background-color: white;
    width: 500px;
    max-height: 80vh;
    overflow-y: auto;
    border-radius: 16px;
    padding: 20px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    position: relative;
}

.grid {
    margin-top: auto; /* This will push the button to the bottom of the modal */
}
</style>

