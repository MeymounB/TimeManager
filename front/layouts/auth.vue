<script setup lang="ts">

</script>

<template>
<section class="auth-layout bg-office-pattern bg-no-repeat bg-cover h-screen w-full">
  <section class="blur-overlay backdrop-blur h-full w-full">
    <div class="bg-white bg-opacity-95 w-5/6 w-full sm:w-2/3 lg:w-1/2 h-full p-5 ml-auto">
        <NuxtLink to="/" class="hover:underline flex items-center">
          <svg-icon name="back-arrow" class="w-3 h-3 mr-2" /> Retour
        </NuxtLink>
      <div class="flex-wrap content-center flex h-full">
        <slot />
      </div>
    </div>
  </section>
</section>
</template>