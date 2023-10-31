<script setup lang="ts">
import AppHeader from "~/components/AppHeader.vue";
</script>

<template>
  <section class="default-layout">
    <AppHeader />
    <main class="w-100 h-100">
      <slot />
    </main>
  </section>
</template>

<style scoped lang="scss">
.default-layout {
}
</style>
