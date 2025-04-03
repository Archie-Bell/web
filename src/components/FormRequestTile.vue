<template>
    <div class="request-tile cursor-pointer hover:bg-gray-700 hover:bg-opacity-40">
        <h3>{{ age ? `${name}, ${age}` : `${name}`}}</h3>
        <p>Submitted by {{ reporter_legal_name }} {{ time_since_submission }}.</p>
        <p><strong>Submission ID:</strong> {{ id }}</p>
    </div>
</template>

<script setup>
import { ref } from 'vue';

const props = defineProps({
    id: String,
    name: String,
    age: Number,
    reporter_legal_name: String,
    time_since_submission: String,
});
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