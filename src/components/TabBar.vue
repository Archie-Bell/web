<template>
    <div class="flex gap-2">
        <button 
            @click="selectedTab(0)" 
            :disabled="disabled"
            :class="{
                'hover:bg-opacity-40': !disabled,
                'bg-gray-600 text-gray-300 bg-opacity-50 cursor-not-allowed outline-gray-300': disabled
            }"
            class="px-4 py-2"
        >
            Overview
        </button>
        <button 
            @click="selectedTab(1)" 
            :disabled="disabled"
            :class="{
                'hover:bg-opacity-40': !disabled,
                'bg-gray-600 text-gray-300 bg-opacity-50 cursor-not-allowed outline-gray-300': disabled
            }"
            class="px-4 py-2"
        >
            Contact
        </button>
        
        <!-- Show Approve and Reject buttons only for Pending status -->
        <button 
            v-if="formStatus === 'pending'"
            @click="openApproveDialog" 
            :disabled="disabled"
            :class="{
                'backdrop-blur-[10px] hover:bg-opacity-50 hover:bg-green-500': !disabled,
                'bg-gray-600 text-gray-300 bg-opacity-50 cursor-not-allowed outline-gray-300': disabled
            }"
            class="px-4 py-2"
        >
            Approve
        </button>
        <button 
            v-if="formStatus === 'pending'"
            @click="openRejectDialog" 
            :disabled="disabled"
            :class="{
                'backdrop-blur-[10px] hover:bg-opacity-50 hover:bg-red-500': !disabled,
                'bg-gray-600 text-gray-300 bg-opacity-50 cursor-not-allowed outline-gray-300': disabled
            }"
            class="px-4 py-2"
        >
            Reject
        </button>

        <button
            v-if="formStatus === 'approved'"
            :disabled="disabled"
            @click="selectedTab(2)"
            :class="{
                'hover:bg-opacity-40': !disabled,
                'bg-gray-600 text-gray-300 bg-opacity-50 cursor-not-allowed outline-gray-300': disabled
            }"
            class="px-4 py-2"
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
