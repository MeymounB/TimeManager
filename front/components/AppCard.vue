<script setup lang="ts">
defineProps<{
  title?: string;
}>();
</script>

<template>
  <section class="bg-white shadow-md border-t rounded-lg py-5 px-7">
    <div v-if="title" class="title bg-gray-300">
      <h3 class="text-2xl h3">{{ title }}</h3>
    </div>
    <div class="content">
      <slot />
    </div>
  </section>
</template>

<style scoped>
.app-card {
  border: 1px solid #181818;
  border-radius: 10px;
  box-shadow:
    0 1px 3px 0 rgb(0 0 0 / 0.1),
    0 1px 2px -1px rgb(0 0 0 / 0.1);

  .title {
    padding: 16px 32px;
    border-radius: 10px 10px 0 0;
  }

  .content {
    padding: 16px 32px;
    min-height: fit-content;
  }
}
</style>
