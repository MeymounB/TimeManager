<template>
  <Listbox v-model="vModel" class="relative" as="div">
    <ListboxButton
      v-if="disabled"
      class="px-4 py-2 rounded border cursor-not-allowed"
      disabled
      >{{ options.find((data) => data.id === vModel)?.name }}</ListboxButton
    >
    <ListboxButton v-else class="px-4 py-2 rounded border">{{
      options.find((data) => data.id === vModel)?.name
    }}</ListboxButton>
    <ListboxOptions
      class="p-5 border rounded shadow-lg space-y-4 mt-2 absolute bg-white w-full list-none"
      as="div"
    >
      <ListboxOption
        v-for="option in options"
        :key="option.id"
        :value="option.id"
        class="border-b"
      >
        {{ option.name }}
      </ListboxOption>
    </ListboxOptions>
  </Listbox>
</template>

<script setup lang="ts">
import { computed } from "vue";
import {
  Listbox,
  ListboxButton,
  ListboxOptions,
  ListboxOption,
} from "@headlessui/vue";

const props = defineProps<{
  modelValue: number;
  options: { id: number; name: string }[];
  disabled: boolean;
}>();

const emit = defineEmits(["update:modelValue"]);

const vModel = computed({
  get: () => props.modelValue,
  set: (value) => emit("update:modelValue", value),
});
</script>
