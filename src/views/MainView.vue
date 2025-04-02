<script setup>
import { onMounted, ref } from "vue";
import FormService from "@/services/FormService";
import { RouterLink } from "vue-router";

const name = ref("Test");
const age = ref(18);
const last_location_seen = ref("Test");
const last_date_time_seen = ref("");
const additional_info = ref("Test");
const image = ref(null);
const image_uri = ref(null);
const reporter_legal_name = ref("Test");
const reporter_phone_number = ref("(123) 456-7890");

const submit = async () => {
    console.log("Submitting form...");

    if (!image_uri.value) {
        console.log("No image was selected for submission");
    }

    try {
        const formData = new FormData();
        formData.append("name", name.value);
        formData.append("age", age.value);
        formData.append("last_location_seen", last_location_seen.value);
        formData.append("last_date_time_seen", last_date_time_seen.value);
        formData.append("additional_info", additional_info.value);
        formData.append("image", image_uri.value.split(",")[1]);
        formData.append("reporter_legal_name", reporter_legal_name.value);
        formData.append("reporter_phone_number", reporter_phone_number.value);

        await FormService.submitForm(formData);
        console.log("Form submitted successfully");
    } catch (e) {
        console.error("Form submission failed: ", e);
    }
};

const formatPhoneInput = () => {
    let number = reporter_phone_number.value.replace(/\D/g, "");

    if (number.length === 0) {
        reporter_phone_number.value = "";
    } else if (number.length <= 3) {
        reporter_phone_number.value = `(${number}`;
    } else if (number.length <= 6) {
        reporter_phone_number.value = `(${number.slice(0, 3)}) ${number.slice(
            3
        )}`;
    } else {
        reporter_phone_number.value = `(${number.slice(0, 3)}) ${number.slice(
            3,
            6
        )}-${number.slice(6, 10)}`;
    }
};

const handleImageChange = (event) => {
    const file = event.target.files[0];
    if (file) {
        image.value = file;

        const reader = new FileReader();
        reader.onload = (e) => {
            image_uri.value = e.target.result;
        };
        reader.readAsDataURL(file);
    } else {
        console.log("No image was given");
        image.value = null;
        image_uri.value = null;
    }
};

const getLocalDateTime = () => {
    const now = new Date();
    const timezoneOffset = now.getTimezoneOffset();

    const adjustedDate = new Date(now.getTime() - timezoneOffset * 60000);

    return adjustedDate.toISOString().slice(0, 16);
};

onMounted(() => {
    last_date_time_seen.value = getLocalDateTime();
});
</script>

<template>
    <div class="p-2 grid content-end place-items-end">
        <RouterLink class="btn btn-blue" to="/s/admin-panel">ADMIN PANEL</RouterLink>
    </div>

    <div class="p-10 grid content-center place-items-center h-screen">
        <h1 class="font-bold uppercase text-3xl">Archie Bell</h1>

        <div class="pt-5 grid grid-cols-12 content-center place-items-center">
            <div class="col-span-12 grid grid-cols-12">
                <div class="col-span-4">
                    <label for="name" class="mr-2 block content-center"
                        >Name</label
                    >
                    <input
                        type="text"
                        name="name"
                        v-model="name"
                        id="name"
                        placeholder="John Doe"
                        class="border rounded-lg p-2"
                    />

                    <label for="age" class="mr-2 block content-center pt-2"
                        >Age</label
                    >
                    <input
                        type="number"
                        name="age"
                        min="0"
                        value="0"
                        v-model="age"
                        id="age"
                        placeholder="18"
                        class="border rounded-lg p-2"
                    />

                    <label
                        for="reporter_legal_name"
                        class="mr-2 block content-center pt-2"
                        >Your Name</label
                    >
                    <input
                        type="text"
                        name="reporter_legal_name"
                        v-model="reporter_legal_name"
                        id="reporter_legal_name"
                        placeholder="Jane Doe"
                        class="border rounded-lg p-2"
                    />
                </div>

                <div class="col-span-4 mx-4">
                    <label for="name" class="mr-2 block content-center"
                        >Last Location Seen</label
                    >
                    <input
                        type="text"
                        name="last_location_seen"
                        v-model="last_location_seen"
                        id="last_location_seen"
                        placeholder="Moose Jaw, SK"
                        class="border rounded-lg p-2"
                    />

                    <label for="name" class="mr-2 block content-center pt-2"
                        >Last Date & Time Seen</label
                    >
                    <input
                        type="datetime-local"
                        name="last_date_time_seen"
                        v-model="last_date_time_seen"
                        id="last_date_time_seen"
                        class="border rounded-lg p-2"
                    />

                    <label
                        for="reporter_phone_number"
                        class="mr-2 block content-center pt-2"
                        >Your Phone Number</label
                    >
                    <input
                        type="text"
                        name="reporter_phone_number"
                        v-model="reporter_phone_number"
                        id="reporter_phone_number"
                        @input="formatPhoneInput"
                        placeholder="(123) 456-7890"
                        class="border rounded-lg p-2"
                    />
                </div>

                <div class="col-span-4 justify-self-center">
                    <label for="image" class="mr-2 block content-center"
                        >Image</label
                    >
                    <!-- Placeholder Image -->
                    <div v-if="image_uri">
                        <img
                            :src="image_uri"
                            class="block justify-center overflow-hidden w-24 h-24"
                            alt="Image"
                            height="90"
                            width="90"
                            id="image"
                            name="image"
                        />
                    </div>

                    <div v-else>
                        <img
                            src="@/assets/placeholders/images/placeholder-img.jpg"
                            class="block justify-center"
                            alt="Image"
                            height="90"
                            width="90"
                            id="image"
                            name="image"
                        />
                    </div>

                    <!-- File Input and Custom Label -->
                    <input
                        type="file"
                        id="image_input"
                        name="image"
                        accept="image/png, image/jpg, image/jpeg"
                        class="hidden"
                        @change="handleImageChange"
                    />
                    <label
                        for="image_input"
                        class="cursor-pointer underline mt-1 font-bold text-sm"
                        >Choose Image</label
                    >
                </div>
            </div>

            <div class="col-span-12 py-2">
                <label for="additonalInfo" class="mr-2 block content-center"
                    >Additional Info</label
                >
                <textarea
                    name="additional_info"
                    v-model="additional_info"
                    id="additional_info"
                    cols="78"
                    rows="5"
                    wrap="hard"
                    maxlength="200"
                    class="border rounded-lg p-2 resize-none"
                    placeholder="Add extra information about this person here. (optional)"
                ></textarea>
            </div>
        </div>
        <button @click="submit" class="btn btn-blue">SUBMIT FORM</button>
        <p class="pt-5" style="border-bottom: 1px dotted #000; display: inline">
            Archie Bell prototype, Capstone 2025. Everything is subject to
            change.
        </p>
    </div>
</template>
