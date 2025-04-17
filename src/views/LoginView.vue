<template>
    <button class="absolute top-5 left-5 hover:bg-red-500 hover:bg-opacity-50" @click="router.push('/')">Back</button>
    <div class="grid content-center place-items-center h-screen">
      
    <div class="pt-5">
      <h1 class="text-3xl uppercase">Admin Panel</h1>
      <label class="block content-center font-bold mb-1 md:mb-0 pr-4 pt-5" for="email">Email</label>
      <input type="email" name="email" id="email" v-model="email" placeholder="john@appleseed.com" />

      <label class="block content-center font-bold mb-1 md:mb-0 pr-4 pt-3" for="password">Password</label>
      <input type="password" name="password" id="password" v-model="password" placeholder="Enter your password"/>
    </div>

    <p v-if="error_response" class="text-red-500 font-bold absolute bottom-20 bg-red-300 bg-opacity-30 backdrop-blur-[20px] px-5 py-2 rounded-full outline outline-4 outline-red-500">{{ error_response }}</p>

    <button class="place-self-center mt-5 min-w-[10rem]" @click="login">LOGIN</button>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import AuthService from "@/services/AuthService.js";
import router from "@/router/index.js";

const email = ref('');
const password = ref('');
const error_response = ref(null);

const login = async () => {
  console.log('Authenticating user', email.value);
  try {
    const response = await AuthService.login({
      email: email.value,
      password: password.value,
    });

    console.log('Bearer', response.data.token);
    localStorage.setItem('token', response.data.token);
    await router.push('/s/admin-panel');
  } catch (e) {
    error_response.value = 'Invalid credentials.'
    console.error('Authentication failed: ', e);
  }
}
</script>