<template>
    <div class="request-tile cursor-default">
        <h3 class="font-bold"> {{ submission_status === 'Pending' ? 'Pending Submission' : 'Rejected Submission' }} {{ index }}</h3>
        <p>{{ submission_status === 'Pending' ? 'Submitted' : 'Updated' }} {{ time_since_submission }}.</p>
        <p><strong>Submission status:</strong> {{ submission_status }}</p>
        <div v-if="submission_status === 'Rejected'">
            <p class="font-bold">Rejection reason:</p>
            <p class="break-all max-w-[30rem]">- {{ rejection_reason }}</p>
            <p class="absolute bottom-0 left-0 ps-[0.6rem] pb-1"><strong>Submission ID:</strong> {{ id }}</p>
            <p><strong>Updated by:</strong> {{ updated_by }}</p>
        </div>
        <p v-else><strong>Submission ID:</strong> {{ id }}</p>

        <!-- Button positioned at the bottom right -->
        <button v-if="submission_status === 'Pending'" class="absolute bottom-4 right-4 px-4 py-2 bg-black bg-opacity-30" @click="openReviewDialog">
            Review
        </button>

        <button v-else class="absolute bottom-4 right-4 px-4 py-2 bg-black bg-opacity-30 hover:bg-red-500 hover:bg-opacity-50" @click="deleteRejectedSubmission(id)">
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
    updated_by: String,
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
h3 {
    margin: 0;
    font-size: 1.2em;
    font-weight: bold;
}

p {
    margin: 5px 0;
    font-size: 0.9em;
}
</style>
