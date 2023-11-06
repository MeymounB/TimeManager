<script setup lang="ts">
import AppHeader from "~/components/AppHeader.vue";
// import AppFooter from "~/components/AppFooter.vue";
</script>

<template>
  <section class="default-layout flex flex-col min-h-screen w-full">
    <AppHeader />
    <main class="flex-grow">
      <slot />
    </main>
    <AppFooter />
  </section>
</template>

<style lang="scss">
html {
  background: white;
}
</style>
