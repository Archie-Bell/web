<script setup>
import { onMounted, ref } from "vue";
import FormService from "@/services/FormService";
import router from "@/router/index.js";

const name = ref("");
const age = ref("");
const last_location_seen = ref("");
const last_date_time_seen = ref("");
const additional_info = ref("");
const image = ref(null);
const image_uri = ref(null);
const reporter_legal_name = ref("");
const reporter_phone_number = ref("");

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
            const img = new Image();
            img.onload = () => {
                // Desired cropped size in pixels (12.6rem = 201.6px)
                const targetSize = 201.6;

                // Calculate center crop (square)
                const cropSize = Math.min(img.width, img.height);
                const cropX = (img.width - cropSize) / 2;
                const cropY = (img.height - cropSize) / 2;

                // Create canvas with desired display size
                const canvas = document.createElement("canvas");
                canvas.width = targetSize;
                canvas.height = targetSize;

                const ctx = canvas.getContext("2d");

                // Draw cropped and scaled image to fit the target size
                ctx.drawImage(
                    img,
                    cropX,
                    cropY,
                    cropSize,
                    cropSize,
                    0,
                    0,
                    targetSize,
                    targetSize
                );

                image_uri.value = canvas.toDataURL("image/jpeg");
            };
            img.src = e.target.result;
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
    <button class="absolute top-5 right-5 min-w-[10rem]" @click="router.push('/s/admin-panel')">Admin Panel</button>

    <div class="p-10 grid place-items-center h-screen">
        <div class="w-full max-w-4xl p-8 rounded-lg">
            <h1 class="font-bold uppercase text-3xl mb-6">Archie Bell</h1>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <div class="space-y-4">
                    <label for="name" class="mr-2 block">Name</label>
                    <input
                        type="text"
                        name="name"
                        v-model="name"
                        id="name"
                        placeholder="John Doe"
                        class="border rounded-lg p-2 w-full"
                    />

                    <label for="age" class="mr-2 block">Age</label>
                    <input
                        type="number"
                        name="age"
                        min="0"
                        value="0"
                        v-model="age"
                        id="age"
                        placeholder="18"
                        class="border rounded-lg p-2 w-full"
                    />

                    <label for="reporter_legal_name" class="mr-2 block">Your Name</label>
                    <input
                        type="text"
                        name="reporter_legal_name"
                        v-model="reporter_legal_name"
                        id="reporter_legal_name"
                        placeholder="Jane Doe"
                        class="border rounded-lg p-2 w-full"
                    />
                </div>

                <div class="space-y-4">
                    <label for="last_location_seen" class="mr-2 block">Last Location Seen</label>
                    <input
                        type="text"
                        name="last_location_seen"
                        v-model="last_location_seen"
                        id="last_location_seen"
                        placeholder="Moose Jaw, SK"
                        class="border rounded-lg p-2 w-full"
                    />

                    <label for="last_date_time_seen" class="mr-2 block">Last Date & Time Seen</label>
                    <input
                        type="datetime-local"
                        name="last_date_time_seen"
                        v-model="last_date_time_seen"
                        id="last_date_time_seen"
                        class="border rounded-lg p-2 w-full"
                    />

                    <label for="reporter_phone_number" class="mr-2 block">Your Phone Number</label>
                    <input
                        type="text"
                        name="reporter_phone_number"
                        v-model="reporter_phone_number"
                        id="reporter_phone_number"
                        @input="formatPhoneInput"
                        placeholder="(123) 456-7890"
                        class="border rounded-lg p-2 w-full"
                    />
                </div>

                <div class="space-y-4">
                    <label for="image" class="mr-2 block text-center">Image</label>
                    <div v-if="image_uri">
                        <img
                            :src="image_uri"
                            class="block min-w-[12.6rem] min-h-[12.6rem] max-w-[12.6rem] max-h-[12.6rem] object-cover mx-auto"
                            alt="Image"
                            id="image"
                            name="image"
                        />
                    </div>

                    <div v-else>
                        <img
                            src="@/assets/placeholders/images/placeholder-img.jpg"
                            class="block min-w-[12.6rem] min-h-[12.6rem] max-w-[12.6rem] max-h-[12.6rem] object-cover mx-auto"
                            alt="Image"
                            id="image"
                            name="image"
                        />
                    </div>

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
                        class="cursor-pointer underline mt-1 font-bold text-sm text-center block"
                        >Choose Image</label
                    >
                </div>
            </div>

            <div class="col-span-full py-4">
                <label for="additional_info" class="mr-2 block">Additional Info</label>
                <textarea
                    name="additional_info"
                    v-model="additional_info"
                    id="additional_info"
                    cols="78"
                    rows="5"
                    wrap="hard"
                    maxlength="200"
                    class="border rounded-lg p-2 w-full resize-none"
                    placeholder="Add extra information about this person here. (optional)"
                ></textarea>
            </div>
            
            <div class="flex justify-center py-4">
                <button @click="submit" class="min-w-[10rem]">
                    SUBMIT FORM
                </button>
            </div>

            <div class="flex justify-center pt-5">
                <p class="text-center" style="border-bottom: 1px dotted #fff; display: inline">
                    Archie Bell prototype, Capstone 2025. Everything is subject to change.
                </p>
            </div>

        </div>
    </div>
</template>
