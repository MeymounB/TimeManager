<script setup lang="ts">
definePageMeta({
  layout: 'auth'
})
</script>

<template>
  <section class="w-full">
    <div class="text-center">
      <h2 class="text-4xl h1 font-bold italic">Créer un compte</h2>
    </div>
    <form class="mt-15 space-y-6 p-5">
      <div class="flex gap-5 flex-col md:flex-row">
        <div class="w-full">
          <label for="firstname" class="block text-sm font-medium leading-6">Prénom</label>
          <div>
            <input id="firstname" name="firstname" type="text" capitalize="true" autocomplete="firstname" required class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6">
          </div>
        </div>

        <div class="w-full">
          <label for="lastname" class="block text-sm font-medium leading-6">Nom</label>
          <div>
            <input id="lastname" name="lastname" type="text" capitalize="true" autocomplete="lastname" required class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6">
          </div>
        </div>
      </div>
      <div>

      </div>
      <div>
        <label for="email" class="block text-sm font-medium leading-6">Email</label>
        <div>
          <input id="email" name="email" type="email" autocomplete="email" required class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6">
        </div>
      </div>

      <div>
        <label for="password" class="block text-sm font-medium leading-6">Mot de passe</label>
        <div>
          <input id="password" name="password" type="password" autocomplete="password" required class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6">
        </div>
      </div>

      <div>
        <label for="confirmPassword" class="block text-sm font-medium leading-6">Répétez le mot de passe</label>
        <div>
          <input id="confirmPassword" name="confirmPassword" type="password" required class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6">
        </div>
      </div>

      <div class="errors min-h-[52px] text-red-500">
        <template v-if="false">
          Oui
        </template>
      </div>

      <AppButton type="submit" :button-style="'primary'" class="flex items-center justify-center w-full">
        Créer un compte
      </AppButton>
    </form>
  </section>
</template>

<style scoped>

</style>