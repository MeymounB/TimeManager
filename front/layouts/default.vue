<script setup lang="ts"></script>

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
