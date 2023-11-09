<script setup lang="ts">
import AppSpinner from "~/components/AppSpinner.vue";

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
    :disabled="isDisabled || isLoading"
  >
    <template v-if="isLoading">
      <AppSpinner />
    </template>
    <slot v-else />
  </button>
</template>
