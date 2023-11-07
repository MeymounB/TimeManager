<script lang="ts" setup>
import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";

const session = useSessionStore();
const { user } = storeToRefs(session);
</script>

<template>
  <nav class="text-md font-semibold">
    <ul
      class="flex flex-col items-center lg:flex-row decoration-0 lg:space-x-8 space-y-10 lg:space-y-0"
    >
      <li class="text-2xl lg:text-base">
        <NuxtLink to="/session/dashboard" class="link p-2">Dashboard</NuxtLink>
      </li>
      <li class="text-2xl lg:text-base">
        <NuxtLink to="/session/users" class="link p-2">Utilisateurs</NuxtLink>
      </li>
      <li class="text-2xl lg:text-base">
        <AppDropdown>
          <template #dropdown-toggle>
            <span>Temps de travail</span>
          </template>
          <template #dropdown-content>
            <nav class="w-52">
              <ul class="space-y-2 w-full">
                <li>
                  <NuxtLink
                    class="link w-full flex items-center px-4 py-2 rounded hover:bg-gray-200"
                    to="/session/workingtimes/me"
                  >
                    Mes sessions
                  </NuxtLink>
                </li>
                <li>
                  <NuxtLink
                    class="link w-full flex items-center px-4 py-2 rounded hover:bg-gray-200"
                    to="/session/workingtimes/teams"
                    >Sessions par équipes
                  </NuxtLink>
                </li>
                <li>
                  <NuxtLink
                    class="link w-full flex items-center px-4 py-2 rounded hover:bg-gray-200"
                    to="/session/workingtimes"
                  >
                    Toutes les sessions
                  </NuxtLink>
                </li>
              </ul>
            </nav>
          </template>
        </AppDropdown>
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
