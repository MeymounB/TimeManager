<script lang="ts" setup>
import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";
import { isUserAdmin, isUserManager } from "~/composables/user";
import type { IUser } from "~/utils/user";

const session = useSessionStore();
const { user } = storeToRefs(session);

const userAdmin = computed(() => {
  return isUserAdmin(user.value as IUser);
});

const userManager = computed(() => {
  return isUserManager(user.value as IUser);
});
</script>

<template>
  <nav class="text-md font-semibold">
    <ul
      class="flex flex-col items-center lg:flex-row decoration-0 lg:space-x-8 space-y-10 lg:space-y-0"
    >
      <li class="text-2xl lg:text-base">
        <NuxtLink to="/session/dashboard" class="link p-2">
          Tableau de bord
        </NuxtLink>
      </li>
      <li class="text-2xl lg:text-base">
        <NuxtLink to="/session/teams" class="link p-2">Équipes</NuxtLink>
      </li>
      <li class="text-2xl lg:text-base">
        <NuxtLink to="/session/users" class="link p-2">Utilisateurs</NuxtLink>
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
