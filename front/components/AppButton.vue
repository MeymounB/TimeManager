<script setup lang="ts">
defineProps<{
  type: "submit" | "button";
  buttonStyle: "primary" | "secondary" | "danger" | "tertiary";
  isLoading?: boolean;
  isDisabled?: boolean;
}>();
</script>

<template>
  <button
    :class="`btn btn-${buttonStyle} disabled:opacity-30 disabled:cursor-not-allowed`"
    :type="type"
    role="button"
    :disabled="isDisabled"
  >
    <slot />
  </button>
</template>
