<script setup lang="ts">
defineProps<{
  type: 'submit' | 'button'
  buttonStyle: 'primary' | 'secondary' | 'danger'
  isLoading?: boolean
  isDisabled?: boolean
}>()
</script>

<template>
  <button :class="`btn btn-${buttonStyle}`" :type="type" role="button">
    <slot />
  </button>
</template>