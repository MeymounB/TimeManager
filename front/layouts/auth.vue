<script setup lang="ts">

</script>

<template>
<section class="auth-layout bg-office-pattern bg-no-repeat bg-cover h-screen w-full">
  <section class="blur-overlay backdrop-blur h-full w-full flex items-center justify-center">
    <div class="bg-white bg-opacity-95 rounded-lg shadow-lg w-5/6 sm:w-2/3 lg:w-1/2 h-2/3 p-5">
      <NuxtLink to="/" class="hover:underline flex items-center">
        <svg-icon name="back-arrow" class="w-3 h-3 mr-2" /> Retour
      </NuxtLink>
      <slot />
    </div>
  </section>
</section>
</template>

<style>
</style>