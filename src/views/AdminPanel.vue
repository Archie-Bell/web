<template>
  <div class="p-10 grid h-screen">
    <header>
      <h1 class="font-bold uppercase text-3xl">Admin Panel</h1>
      <div class="flex gap-1">
        <button @click="showActiveSearches" class="btn btn-blue uppercase">Active Searches</button>
        <button @click="logout" class="btn btn-red uppercase">Logout</button>
      </div>
    </header>

    <div class="flex flex-1 mt-5"> <!-- Make sure it takes up the full height and uses flexbox -->
      <!-- Left Panel -->
      <div class="pe-5 flex-[1] pt-3 overflow-y-auto" style="max-height: 600px; flex-grow: 1;">
        <h2 class="text-xl font-bold">Recent Form Requests</h2>
        <div v-for="(request, index) in requests" :key="index">
          <FormRequestTile class="rounded-xl" :title="request.title" @select-request="onRequestSelected" />
        </div>
      </div>

      <!-- Right Panel -->
      <div class="ps-5 flex-[2]">
        <RequestDetails :selectedTab="selectedTab" :requestTitle="selectedRequest" @tab-selected="onTabSelected" />
      </div>
    </div>

    <!-- Active Searches Dialog -->
    <ActiveSearchesDialog v-if="isActiveSearchesDialogOpen" @close="closeActiveSearchesDialog" />
  </div>
</template>

<script setup>
import { ref } from 'vue';
import FormRequestTile from '@/components/FormRequestTile.vue';
import RequestDetails from '@/components/RequestDetails.vue';
import ActiveSearchesDialog from '@/components/ActiveSearchesDialog.vue';
import { useRouter } from 'vue-router';

const selectedTab = ref(0);
const selectedRequest = ref('');
const isActiveSearchesDialogOpen = ref(false);

const router = useRouter();

// Temporary request data
const requests = [
  { title: 'Missing Person 1' },
  { title: 'Missing Person 2' },
  { title: 'Missing Person 3' },
  { title: 'Missing Person 4' },
  { title: 'Missing Person 5' },
  { title: 'Missing Person 6' },
  { title: 'Missing Person 7' },
];

// Handle request selection
const onRequestSelected = (requestTitle) => {
  selectedRequest.value = requestTitle;
};

// Handle tab selection
const onTabSelected = (tabIndex) => {
  selectedTab.value = tabIndex;
};

// Show Active Searches dialog
const showActiveSearches = () => {
  isActiveSearchesDialogOpen.value = true;
};

// Close Active Searches dialog
const closeActiveSearchesDialog = () => {
  isActiveSearchesDialogOpen.value = false;
};

// Logout logic (to be implemented)
const logout = () => {
  console.log('Logging out...');
  router.push('/');
};
</script>

<style scoped>
/* Make sure the container takes up full height */
.grid {
  display: grid;
  grid-template-rows: auto 1fr; /* Header and content */
}

header {
  padding-bottom: 20px;
}

.flex {
  display: flex;
  flex-grow: 1;
}

.pe-5 {
  padding-right: 1.25rem;
}

.ps-5 {
  padding-left: 1.25rem;
}

.flex-1 {
  flex: 1;
}

.flex-2 {
  flex: 2;
}

/* Ensure that content within the left panel scrolls properly */
.left-panel {
  overflow-y: auto;
  max-height: 600px; /* Adjust the max height as necessary */
}

/* Make sure that the content adjusts for smaller screens */
@media (max-width: 768px) {
  .flex {
    flex-direction: column; /* Stack the left and right panels vertically on smaller screens */
  }

  .pe-5 {
    padding-right: 0;
  }

  .ps-5 {
    padding-left: 0;
  }
}
</style>