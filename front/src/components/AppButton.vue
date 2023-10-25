<script setup lang="ts">
defineProps<{
  type: 'submit' | 'button'
  isLoading?: boolean
  isDisabled?: boolean
}>()
</script>

<template>
  <button class="app-button" :type="type" role="button">
    <slot />
  </button>
</template>

<style scoped>
.app-button {
  padding: 8px 16px;
  border: 1px solid #181818;
  border-radius: 8px;
  min-width: 200px;
  color: #181818;
}
</style>