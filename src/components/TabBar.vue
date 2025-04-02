<template>
    <div class="flex gap-1">
        <button 
            @click="selectedTab(0)" 
            :disabled="disabled"
            :class="{
                'bg-blue-500 text-white hover:bg-blue-400': !disabled,
                'bg-gray-300 text-gray-500 cursor-not-allowed': disabled
            }"
            class="px-4 py-2 rounded-md transition-colors duration-200 font-bold"
        >
            Overview
        </button>
        <button 
            @click="selectedTab(1)" 
            :disabled="disabled"
            :class="{
                'bg-blue-500 text-white hover:bg-blue-400': !disabled,
                'bg-gray-300 text-gray-500 cursor-not-allowed': disabled
            }"
            class="px-4 py-2 rounded-md transition-colors duration-200 font-bold"
        >
            Contact
        </button>
        
        <!-- Show Approve and Reject buttons only for Pending status -->
        <button 
            v-if="formStatus === 'pending'"
            @click="openApproveDialog" 
            :disabled="disabled"
            :class="{
                'bg-green-500 text-white hover:bg-green-400': !disabled,
                'bg-gray-300 text-gray-500 cursor-not-allowed': disabled
            }"
            class="px-4 py-2 rounded-md transition-colors duration-200 font-bold"
        >
            Approve
        </button>
        <button 
            v-if="formStatus === 'pending'"
            @click="openRejectDialog" 
            :disabled="disabled"
            :class="{
                'bg-red-500 text-white hover:bg-red-400': !disabled,
                'bg-gray-300 text-gray-500 cursor-not-allowed': disabled
            }"
            class="px-4 py-2 rounded-md transition-colors duration-200 font-bold"
        >
            Reject
        </button>

        <button
            v-if="formStatus === 'approved'"
            :disabled="disabled"
            @click="selectedTab(2)"
            :class="{
                'bg-blue-500 text-white hover:bg-blue-400': !disabled,
                'bg-gray-300 text-gray-500 cursor-not-allowed': disabled
            }"
            class="px-4 py-2 rounded-md transition-colors duration-200 font-bold"
        >
            Submissions
        </button>
    </div>
</template>

<script setup>
const props = defineProps({
  disabled: {
    type: Boolean,
    default: false,
  },
  formStatus: {  // Add the formStatus prop
    type: String,
    default: 'pending',
  }
});

const emit = defineEmits();

const selectedTab = (val) => {
    console.log(val);
    emit('selected-tab', val);
}

const openApproveDialog = () => {
    emit('open-approve-dialog');
}

const openRejectDialog = () => {
    emit('open-reject-dialog');
}
</script>
