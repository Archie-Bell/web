<template>
    <div class="flex gap-1">
      <button @click="selectTab(0)" class="btn btn-blue">Overview</button>
      <button @click="selectTab(1)" class="btn btn-blue">Contact</button>
      <button @click="selectTab(2)" class="btn btn-blue">Missing Person Information</button>
    </div>
  </template>
  
  <script setup>
  const props = defineProps({
    selectedTab: Number,
  });
  
  const emit = defineEmits(['tab-selected']);
  
  const selectTab = (index) => {
    emit('tab-selected', index);
  };
  </script>
  