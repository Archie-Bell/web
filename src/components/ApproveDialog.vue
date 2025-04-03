<template>
    <div class="modal-container" @click="handleClickOutside">
        <div class="modal p-5 rounded-2xl drop-shadow-xl content-center transition-opacity duration-200" @click.stop>
            <h2 class="font-bold text-2xl">Approve Submission?</h2>
            <div class="grid grid-cols-3 gap-1 pt-1">
                <div class="cols-span-1 content-center">
                    <img :src="image_url" class="rounded-xl" alt="Fetched Data Image" v-if="image_url">
                    <p v-else>Loading image...</p>
                </div>
                
                <div class="ms-5 col-span-2">
                    <p><strong>Submission ID:</strong> {{ id }}</p>
                    <p><strong>Missing person:</strong> {{ name }}, {{ age }}</p>
                    <p><strong>Submitted by:</strong> {{ reporter_legal_name }}</p>
                    <p><strong>Submission date & time:</strong><br/> {{ submission_date }}</p>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-10 content-center pt-5">
              <button @click="approveSubmission(props.id)" class="hover:bg-green-500 hover:bg-opacity-50 col-span-1 transition-colors duration-200">Approve</button>
              <button @click="closeDialog" class="hover:bg-opacity-50 col-span-1 transition-colors duration-200">Cancel</button>
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
    backdrop-filter: blur(5px);
    z-index: 999;
}

.grid {
    margin-top: auto; /* This will push the button to the bottom of the modal */
}
</style>

