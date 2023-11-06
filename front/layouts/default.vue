<script setup lang="ts"></script>

<template>
  <section class="default-layout w-full">
    <AppHeader />
    <main class="w-100 h-100 p-[32px]">
      <slot />
    </main>
  </section>
</template>

<style lang="scss">
html {
  background: white;
}
</style>
