<template>
    <div class="modal-container" @click="handleClickOutside">
        <div class="modal p-5 rounded-2xl drop-shadow-xl content-center" @click.stop>
            <h2 class="font-bold text-2xl">Approve Submission?</h2>
            
            <div class="grid content-center">
              <button @click="closeDialog" class="btn btn-red">Close</button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from "vue";

const emit = defineEmits(["close"]);

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

