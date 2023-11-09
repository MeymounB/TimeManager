<template>
  <nav class="text-md font-semibold">
    <ul
      class="flex flex-col lg:flex-row decoration-0 lg:space-x-8 space-y-10 lg:space-y-0"
    >
      <li class="text-2xl lg:text-base">
        <NuxtLink to="/" class="link">Home</NuxtLink>
      </li>
      <li class="hover:underline text-2xl lg:text-base">
        <NuxtLink to="/guide">Guide</NuxtLink>
      </li>
      <li class="hover:underline text-2xl lg:text-base">
        <NuxtLink to="/contact">Contact</NuxtLink>
      </li>
    </ul>
  </nav>
</template>
<style scoped lang="scss">
.link {
  &.router-link-active {
    @apply font-extrabold;
  }
}
</style>
