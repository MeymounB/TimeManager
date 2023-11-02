<script setup lang="ts">
definePageMeta({
  layout: 'auth'
})
</script>

<template>
<section class="w-full">
  <div class="text-center mt-5">
    <h2 class="text-4xl h1 font-bold italic">TimeManager</h2>
    <span class="text-sm italic">Connectez vous à votre espace</span>
  </div>
  <form class="mt-15 space-y-6 space p-5">
    <div>
      <label for="email" class="block text-sm font-medium leading-6">Email</label>
      <div class="mt-2">
        <input id="email" name="email" type="email" autocomplete="email" required class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6">
      </div>
    </div>

    <div>
      <div class="flex items-center justify-between">
        <label for="password" class="block text-sm font-medium leading-6">Mot de passe</label>
      </div>
      <div class="mt-2">
        <input id="password" name="password" type="password" autocomplete="current-password" required class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6">
      </div>
    </div>

    <div class="errors min-h-[52px] text-red-500">
      <template v-if="false">
        Oui
      </template>
    </div>

    <AppButton type="submit" :button-style="'primary'" class="flex items-center justify-center w-1/3 ml-auto">
      <svg-icon name="login" class="w-4 h-4 mr-3" /> Connexion
    </AppButton>
  </form>
</section>
</template>

<style scoped>

</style>