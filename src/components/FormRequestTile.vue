<template>
    <div class="form-request-tile" @click="handleClick">
      <h3>{{ title }}</h3>
      <p>Submitted by Jane Doe ## minutes ago.</p>
    </div>
  </template>
  
  <script setup>
  const props = defineProps({
    title: String,
  });
  
  const emit = defineEmits(['select-request']);
  
  const handleClick = () => {
    emit('select-request', props.title);
  };
  </script>
  
 <style scoped>
.form-request-tile {
    border: 1px solid #ccc;
    padding: 10px;
    margin-bottom: 10px;
    cursor: pointer;
    max-height: 150px; /* Set a max height for the tile */
    overflow-y: auto; /* Enable vertical scrolling */
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

  