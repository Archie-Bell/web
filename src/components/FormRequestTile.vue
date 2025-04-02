<template>
    <div class="form-request-tile">
        <h3>{{ age ? `${name}, ${age}` : `${name}`}}</h3>
        <p>Submitted by {{ reporter_legal_name }} {{ time_since_submission }}.</p>
        <p>{{ 'Submission ID: ' + id || 'ID not recognised.' }}</p>
    </div>
</template>

<script setup>
import { ref } from 'vue';
const fetchedId = ref('');

const props = defineProps({
    id: String,
    name: String,
    age: Number,
    reporter_legal_name: String,
    time_since_submission: String,
});
</script>

<style scoped>
.form-request-tile {
    border: 1px solid #ccc;
    padding: 10px;
    margin-bottom: 10px;
    cursor: pointer;
    max-height: 150px;
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