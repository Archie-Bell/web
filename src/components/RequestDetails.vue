<template>
    <div class="pt-3">
        <h2 class="font-bold uppercase text-2xl">UNIMPLEMENTED LOGIC</h2>

        <TabBar />
        <div
            class="grid relative justify-center top-[15rem]"
            v-if="name === ''"
        >
            <p>Select a form to view the details</p>
        </div>
    </div>
</template>

<script setup>
import { ref } from "vue";
import TabBar from "./TabBar.vue";

const id = ref('');
const name = ref('');
</script>
