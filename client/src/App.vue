<script setup>

</script>

<template>
  <div class="p-10 grid content-center place-items-center h-screen">
    <h1 class="font-bold uppercase text-3xl">Archie Bell Missing Persons Form</h1>

    <div class="pt-5 grid grid-cols-12 content-center place-items-center">

      <div class="col-span-6 mr-7">
        <label for="name" class="mr-2 block content-center">Name</label>
        <input type="text" name="name" :bind="name" id="name" placeholder="John Doe" class="border rounded-lg p-2">   

        <label for="age" class="mr-2 block content-center pt-2">Age</label>
        <input type="number" name="age" min="0" value="0" :bind="age" id="age" placeholder="18" class="border rounded-lg p-2">   
      </div>

      <div class="col-span-6 ml-7">
        <label for="name" class="mr-2 block content-center">Last Location Seen</label>
        <input type="text" name="lastLocationSeen" :bind="lastLocationSeen" id="lastLocationSeen" placeholder="Moose Jaw, SK" class="border rounded-lg p-2">

        <label for="name" class="mr-2 block content-center pt-2">Last Date & Time Seen</label>
        <input type="datetime-local" name="lastDateTimeSeen" :bind="lastDateTimeSeen" id="lastDateTimeSeen" placeholder="12:00 PM" class="border rounded-lg p-2">
      </div>

    </div>

    <div class="py-2">
        <label for="additonalInfo" class="mr-2 block content-center">Additional Info</label>
        <textarea name="additionalInfo" id="additionalInfo" cols="50" rows="5" wrap="hard" maxlength="200" class="border rounded-lg p-2 resize-none" placeholder="Add extra information about this person here. (optional)"></textarea>
    </div>

    <button :click="submit" class="btn btn-blue">SUBMIT FORM</button>

  </div>
</template>