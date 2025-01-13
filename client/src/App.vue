<script setup>
import { onMounted, ref } from 'vue';
import FormService from '@/services/FormService';
import DateToString from '@/scripts/DateToString'

const name = ref('');
const age = ref(18);
const lastLocationSeen = ref('');
const lastDateTimeSeen = ref('');
const additionalInfo = ref('');
const image = ref(null);
const imageUrl = ref(null);

const submit = async () => {
  console.log('Submitting form...');

  if (imageUrl.value) {
    console.log("Image to Base64: ", imageUrl.value);
  } else {
    console.log("No image was selected for submission");
  }

  try {
    const response = await FormService.submitForm({
      name: name.value,
      age: age.value,
      lastLocationSeen: lastLocationSeen.value,
      lastDateTimeSeen: DateToString.getDate(lastDateTimeSeen.value),
      additionalInfo: additionalInfo.value,
      image: imageUrl.value,
    });

    console.log(response.data);
  } catch (e) {
    console.error('Form submission failed: ', e);
  }
}

const handleImageChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    image.value = file;

    const reader = new FileReader();
    reader.onload = (e) => {
      imageUrl.value = e.target.result;
    };
    reader.readAsDataURL(file);
  } else {
    console.log("No image was given");
    image.value = null;
    imageUrl.value = null;
  }
}

const getLocalDateTime = () => {
  const now = new Date();
  const timezoneOffset = now.getTimezoneOffset();

  const adjustedDate = new Date(now.getTime() - timezoneOffset * 60000);

  return adjustedDate.toISOString().slice(0,16);
}

onMounted(() => {
  lastDateTimeSeen.value = getLocalDateTime();
});

</script>

<template>
  <div class="p-10 grid content-center place-items-center h-screen">
    <h1 class="font-bold uppercase text-3xl">Archie Bell Missing Persons Form</h1>

    <div class="pt-5 grid grid-cols-12 content-center place-items-center">

      <div class="col-span-12 grid grid-cols-12">
        <div class="col-span-4">
          <label for="name" class="mr-2 block content-center">Name</label>
          <input type="text" name="name" v-model="name" id="name" placeholder="John Doe" class="border rounded-lg p-2">   

          <label for="age" class="mr-2 block content-center pt-2">Age</label>
          <input type="number" name="age" min="0" value="0" v-model="age" id="age" placeholder="18" class="border rounded-lg p-2">   
        </div>
        
        <div class="col-span-4 mx-4">
          <label for="name" class="mr-2 block content-center">Last Location Seen</label>
          <input type="text" name="lastLocationSeen" v-model="lastLocationSeen" id="lastLocationSeen" placeholder="Moose Jaw, SK" class="border rounded-lg p-2">

          <label for="name" class="mr-2 block content-center pt-2">Last Date & Time Seen</label>
          <input type="datetime-local" name="lastDateTimeSeen" v-model="lastDateTimeSeen" id="lastDateTimeSeen" class="border rounded-lg p-2">
        </div>

        <div class="col-span-4 justify-self-center">
          <label for="image" class="mr-2 block content-center">Image</label>
          <!-- Placeholder Image -->
          <div v-if="imageUrl">
            <img :src="imageUrl" class="block justify-center overflow-hidden w-24 h-24" alt="Image" height="90" width="90" id="image" name="image">
          </div>

          <div v-else>
            <img src="./assets/placeholders/images/placeholder-img.jpg" class="block justify-center" alt="Image" height="90" width="90" id="image" name="image">
          </div>

          <!-- File Input and Custom Label -->
          <input type="file" id="imageInput" name="image" accept="image/png, image/jpg, image/jpeg" class="hidden" @change="handleImageChange" />
          <label for="imageInput" class="cursor-pointer underline mt-1 font-bold text-sm">Choose Image</label>
        </div>
      </div>

      <div class="col-span-12 py-2">
        <label for="additonalInfo" class="mr-2 block content-center">Additional Info</label>
        <textarea name="additionalInfo" v-model="additionalInfo" id="additionalInfo" cols="78" rows="5" wrap="hard" maxlength="200" class="border rounded-lg p-2 resize-none" placeholder="Add extra information about this person here. (optional)"></textarea>
      </div>
    </div>

    <button @click="submit" class="btn btn-blue">SUBMIT FORM</button>
    <p class="pt-5">All features and functionality are work-in-progress and are subject to change.</p>

  </div>
</template>