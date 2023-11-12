<template>
  <Combobox v-model="vModel">
    <ComboboxInput
      :display-value="(data) => data?.name"
      @change="query = $event.target.value"
    />
    <ComboboxOptions>
      <ComboboxOption
        v-for="option in filteredData"
        :key="option.id"
        v-slot="{ active, selected }"
        :value="option"
        as="template"
      >
        <li
          :class="{
            'bg-blue-500 text-white': active,
            'bg-white text-black': !active,
          }"
        >
          <CheckIcon v-show="selected" />
          {{ option.name }}
        </li>
      </ComboboxOption>
    </ComboboxOptions>
  </Combobox>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import {
  Combobox,
  ComboboxInput,
  ComboboxOptions,
  ComboboxOption,
} from "@headlessui/vue";
import { CheckIcon } from "@heroicons/vue/20/solid";

const props = defineProps<{
  modelValue: { id: number; name: string } | null;
  options: { id: number; name: string }[];
}>();

const emit = defineEmits(["update:modelValue"]);

const vModel = computed({
  get: () => props.modelValue,
  set: (value) => emit("update:modelValue", value),
});
const query = ref("");

const filteredData = computed(() =>
  query.value === ""
    ? props.options
    : props.options.filter((data) => {
        return data.name.toLowerCase().includes(query.value.toLowerCase());
      }),
);
</script>
