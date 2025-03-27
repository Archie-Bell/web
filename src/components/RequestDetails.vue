<template>
    <div class="pt-3">
        <h2 class="font-bold uppercase text-2xl">{{ name && age ? `${name}, ${age}` : 'No Person Selected' }}</h2>

        <TabBar @selected-tab="tabSelectHandler" class="pb-5"/>
        <div v-if="!idRef">
            <p>Select a form to view its details.</p>
        </div>

        <div v-else>
            <div v-if="currentTab === 0">
                <div class="grid grid-cols-3 gap-6">
                    <div class="p-4 border rounded-xl">
                        <!-- Using the ref for the image URL directly -->
                        <img :src="imageUrl" alt="Fetched Data Image" v-if="imageUrl" />
                        <p v-else>Loading image...</p>
                    </div>

                    <div class="p-4 col-span-2 border rounded-xl">
                        <p class="text-lg"><strong>Name:</strong> {{ name }}</p>
                        <p class="text-lg"><strong>Age:</strong> {{ age }}</p>
                        <p class="text-lg"><strong>Last known location:</strong> {{ last_location_seen }}</p>
                        <p class="text-lg"><strong>Last date/time seen:</strong> {{ last_date_time_seen }}</p>
                        <p class="text-lg"><strong>Submitted At:</strong> {{ submission_date }}</p>
                        <p class="text-lg"><strong>Last Updated At:</strong> {{ last_updated_date }}</p>
                        <p class="text-lg"><strong>Additional Info:</strong></p>
                        <p>{{ additional_info }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import TabBar from "./TabBar.vue";
import DataService from '@/services/DataService.js';
import GetTimeSinceSubmission from '@/scripts/GetTimeSinceSubmission.js';

// Initialize refs to store data
const idRef = ref('');
const name = ref('');
const age = ref(0);
const last_location_seen = ref('');
const last_date_time_seen = ref('');
const additional_info = ref('');
const submission_date = ref('');
const last_updated_date = ref('');
const imageUrl = ref(''); // Ref to store the image URL

// Use defineProps to get the id from the parent component
const props = defineProps({
    id: String,
});

// Update the idRef whenever the id prop changes
watch(() => props.id, (newId) => {
    idRef.value = newId;
    fetchSelectedDataContents(idRef.value);
});

// Handle tab selection
const currentTab = ref(0);
const tabSelectHandler = (val) => {
    console.log('Current Tab: ', val);
    currentTab.value = val;
}

// Fetch the data based on the selected id
const fetchSelectedDataContents = async (id) => {
    try {
        const response = await DataService.fetchSingularData(id);
        console.log(response);

        name.value = response.name;
        age.value = response.age;
        last_location_seen.value = response.last_location_seen;
        last_date_time_seen.value = response.last_date_time_seen;
        additional_info.value = response.additional_info;
        submission_date.value = GetTimeSinceSubmission.formatDateOfSubmission(response.submission_date);
        last_updated_date.value = GetTimeSinceSubmission.formatDateOfSubmission(response.last_updated_date);
        
        // Set the image URL
        imageUrl.value = await fetchImageData(response.image_url);
    }
    catch (e) {
        console.error('Failed to fetch specified data:', e);
    }
}

// Fetch image data from the API and return the URL
const fetchImageData = async (image) => {
    try {
        console.log(image);
        const data = await DataService.fetchImageData(image);
        return data; // Assuming this returns a valid URL for the image
    } catch (e) {
        console.error('Error fetching image data:', e);
        return ''; // Return empty string or a fallback image in case of error
    }
}
</script>
