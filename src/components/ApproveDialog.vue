<template>
    <div class="modal-container" @click="handleClickOutside">
        <div class="modal p-5 rounded-2xl drop-shadow-xl content-center" @click.stop>
            <h2 class="font-bold text-2xl">Approve Submission?</h2>
            <div class="grid grid-cols-3 gap-1 pt-1">
                <div class="p-2 border rounded-xl cols-span-1 content-center">
                    <img :src="image_url" alt="Fetched Data Image" v-if="image_url">
                    <p v-else>Loading image...</p>
                </div>
                
                <div class="p-2 border rounded-xl col-span-2">
                    <p><strong>Submission ID:</strong> {{ id }}</p>
                    <p><strong>Missing person:</strong> {{ name }}, {{ age }}</p>
                    <p><strong>Submitted by:</strong> {{ reporter_legal_name }}</p>
                    <p><strong>Submission date & time:</strong><br/> {{ submission_date }}</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-1 content-center pt-1">
              <button @click="approveSubmission(props.id)" class="btn btn-green col-span-1">Approve</button>
              <button @click="closeDialog" class="btn btn-red col-span-1">Cancel</button>
            </div>
        </div>
    </div>
</template>

<script setup>
import FormService from '@/services/FormService';
const emit = defineEmits(["close"]);

const closeDialog = () => {
    emit("close");
};

const approveSubmission = async (id) => {
    try {
        console.log('Attempting to approve submission:', id);

        const data = {
            'submission_id': id,
            'status': 'Approved',
        }

        await FormService.updateSubmission(data);
        console.log('Submission successfully approved:', id)
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

