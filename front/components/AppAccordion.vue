<script setup lang="ts">
import { initFlowbite } from "flowbite";
defineProps<{
  id: string;
}>();

const emit = defineEmits(["open"]);

const accordionOpen = ref(false);
const setAccordionState = () => {
  accordionOpen.value = !accordionOpen.value;

  if (accordionOpen.value === true) {
    emit("open");
  }
};

onMounted(() => {
  initFlowbite();
});
</script>

<template>
  <section class="app-accordion">
    <h2 :id="`${id}-heading`">
      <button
        type="button"
        class="flex items-center justify-between w-full py-5 px-10 font-medium text-left text-gray-500 border-b border-gray-200 dark:border-gray-700 dark:text-gray-400"
        :data-accordion-target="`#${id}-body`"
        aria-expanded="false"
        :aria-controls="`${id}-body`"
        @click="setAccordionState"
      >
        <slot name="header" />
        <svg-icon
          name="dropdown-toggle"
          data-accordion-icon
          class="w-4 h-4 rotate-180 shrink-0"
          aria-hidden="true"
        />
      </button>
    </h2>
    <div :id="`${id}-body`" class="hidden" :aria-labelledby="`${id}-heading`">
      <div class="py-5 px-10 border-b border-gray-200">
        <slot name="content" />
      </div>
    </div>
  </section>
</template>

<style scoped></style>
