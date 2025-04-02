<template>
    <div class="found-submission-tile relative p-4 border rounded-lg">
        <h3 class="font-bold"> {{ submission_status === 'Pending' ? 'Pending Submission' : 'Rejected Submission' }} {{ index }}</h3>
        <p>{{ submission_status === 'Pending' ? 'Submitted' : 'Updated' }} {{ time_since_submission }}.</p>
        <p>Submission status: {{ submission_status }}</p>
        <div v-if="submission_status === 'Rejected'">
            <p>Rejection reason:</p>
            <p class="break-all max-w-[30rem]">- {{ rejection_reason }}</p>
        </div>
        <p>{{ 'Submission ID: ' + id || 'ID not recognised.' }}</p>

        <!-- Button positioned at the bottom right -->
        <button v-if="submission_status === 'Pending'" class="absolute bottom-4 right-4 px-4 py-2 btn btn-blue" @click="openReviewDialog">
            Review
        </button>

        <button v-else class="absolute bottom-4 right-4 px-4 py-2 btn btn-red" @click="deleteRejectedSubmission(id)">
            Delete
        </button>
    </div>
</template>

<script setup>
import DataService from '@/services/DataService';

const emit = defineEmits();

const props = defineProps({
    id: String,
    index: Number,
    submission_status: String,
    time_since_submission: String,
    rejection_reason: String,
});

const openReviewDialog = () => {
    emit('open-review-dialog', props.id);
    console.log('Submission ID:', props.id);
};

const deleteRejectedSubmission = async (id) => {
    console.log('Deleting submission ID:', id);
    await DataService.deleteSpecificRejectedFoundSubmission(id);
}

</script>

<style scoped>
.found-submission-tile {
    border: 1px solid #ccc;
    padding: 10px;
    margin-bottom: 10px;
    cursor: pointer;
    max-height: auto;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
}

h3 {
    margin: 0;
    font-size: 1.2em;
    font-weight: bold;
}

p {
    margin: 5px 0;
    font-size: 0.9em;
    color: #666;
}
</style>
