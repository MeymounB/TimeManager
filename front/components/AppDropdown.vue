<script setup lang="ts">
defineProps<{
  buttonStyle: "primary" | "secondary" | "tertiary" | "danger";
}>();

const toggled = ref(false);

const toggleDropdown = () => {
  console.log("ahhhh");
  toggled.value = !toggled.value;
};
</script>

<template>
  <section class="app-dropdown">
    <AppButton
      :button-style="buttonStyle"
      class="flex items-center space-x-2"
      @click="toggleDropdown"
    >
      <slot name="dropdown-toggle" />
      <svg-icon class="w-5 h-5" name="dropdown-toggle" />
    </AppButton>
    <div
      class="absolute mt-2 rounded-lg bg-white border border-gray-400 p-3 w-full"
      :class="{ hidden: !toggled }"
    >
      <slot name="dropdown-content" />
    </div>
  </section>
</template>

<style scoped></style>
