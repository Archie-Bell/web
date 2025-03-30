<template>
    <div class="grid content-center place-items-center h-screen">
    <h1 class="text-3xl">Welcome Back</h1>

    <div class="py-5">
      <label class="block content-center font-bold mb-1 md:mb-0 pr-4" for="email">Email</label>
      <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="email" name="email" id="email" v-model="email" placeholder="john@appleseed.com" />

      <label class="block content-center font-bold mb-1 md:mb-0 pr-4" for="password">Password</label>
      <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="password" name="password" id="password" v-model="password" placeholder="Enter your password"/>
    </div>

    <button class="place-self-center btn btn-blue" @click="login">LOGIN</button>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import AuthService from "@/services/AuthService.js";
import router from "@/router/index.js";

const email = ref('');
const password = ref('');

const login = async () => {
  console.log('Authenticating user...');
  try {
    const response = await AuthService.login({
      email: email.value,
      password: password.value,
    });

    console.log(response.data.token);
    localStorage.setItem('token', response.data.token);
    await router.push('/s/admin-panel');
  } catch (e) {
    console.error('Authentication failed: ', e);
  }
}
</script>