<template>
    <div class="pt-3">
      <h2 class="font-bold uppercase text-2xl">{{ requestTitle || 'NO PERSON SELECTED' }}</h2>
      <TabBar :selectedTab="selectedTab" @tab-selected="onTabSelected" />
      <div v-if="requestTitle === ''">
        <p>Select a form to view the details</p>
      </div>
      <div v-else>
        <div v-if="selectedTab === 0">
          <p>Overview Tab</p>
        </div>
        <div v-if="selectedTab === 1">
          <p>Contact Tab</p>
        </div>
        <div v-if="selectedTab === 2">
          <p>Missing Person Information Tab</p>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  import TabBar from './TabBar.vue';
  
  const props = defineProps({
    selectedTab: Number,
    requestTitle: String,
  });
  
  const emit = defineEmits(['tab-selected']);
  
  const onTabSelected = (tabIndex) => {
    emit('tab-selected', tabIndex);
  };
  </script>
  