<script setup lang="ts">
defineProps({
  menuItems: {
    type: Array,
    default: () => [],
  },
});
</script>

<template>
  <aside class="sidebar lg:w-64 bg-white">
    <nav
      class="flex lg:flex-col items-center justify-center sticky top-1/2 lg:top-[62px] -translate-y-1/2 lg:translate-y-0 overflow-x-auto lg:overflow-x-hidden"
    >
      <ul class="flex flex-col p-4">
        <li
          v-for="item in menuItems"
          :key="item.name"
          class="border-b border-gray-200"
        >
          <NuxtLink
            :to="item.link"
            class="flex items-center hover:text-blue-600 py-2"
          >
            <slot :name="`icon-${item.name}`"></slot>
            <span class="hidden lg:block">{{ item.title }}</span>
          </NuxtLink>
        </li>
      </ul>
    </nav>
  </aside>
</template>
