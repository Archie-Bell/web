<template>
    <div class="flex gap-1">
        <button class="btn btn-blue" @click="selectedTab(0)">Overview</button>
        <button class="btn btn-blue" @click="selectedTab(1)">Contact</button>
        <button class="btn btn-green" @click="openApproveDialog">Approve</button>
        <button class="btn btn-red" @click="selectedTab(3)">Reject</button>
    </div>
</template>

<script setup>
const emit = defineEmits();

const selectedTab = (val) => {
    console.log(val);
    emit('selected-tab', val)
}

// Emit event for opening the approve dialog
const openApproveDialog = () => {
    emit('open-approve-dialog');
}
</script>
