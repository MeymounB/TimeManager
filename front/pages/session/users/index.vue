<script setup lang="ts">
import { storeToRefs } from "pinia";
import type { IRole } from "~/utils/roles";
import type { IUser, IUserShort } from "~/utils/user";
import { isUserManager } from "~/composables/user";
import { useSessionStore } from "~/stores/sessionStore";

definePageMeta({
  middleware: ["auth"],
});

const session = useSessionStore();
const { user } = storeToRefs(session);
const getAllUser = useGetAllUser();
const getAllRoles = useGetAllRoles();
const users = ref<IUserShort[]>([]);
const roles = ref<IRole[]>([]);
const loading = ref(false);

const fetchAllUsers = async () => {
  loading.value = true;
  const response = await getAllUser();

  if (!response.ok) {
    return alert("Error happened while fetching");
  }

  users.value = response.data;
  loading.value = false;
};

const userByRoleId = computed(() => {
  return users.value.sort((prev: IUserShort, next: IUserShort) => {
    return prev.role_id - next.role_id;
  });
});

const userManager = computed(() => {
  return isUserManager(user.value as IUser);
});

const fetchAllRoles = async () => {
  const response = await getAllRoles();

  if (!response.ok) {
    return alert("Error happened while fetching");
  }

  roles.value = response.data;
};

const getRoleName = (roleId: number) => {
  const role = roles.value.find((role) => role.id === roleId);

  return role?.name ?? "N/A";
};

onMounted(async () => {
  await fetchAllUsers();
  await fetchAllRoles();
});
</script>

<template>
  <section class="users my-10 px-1 lg:px-5">
    <table
      class="w-full lg:w-4/5 h-1/2 text-left text-sm font-light overflow-hidden table-fixed lg:table-auto mx-auto"
    >
      <thead class="border-b font-medium dark:border-neutral-500">
        <tr>
          <th
            scope="col"
            class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap"
          >
            Prénom
          </th>
          <th
            scope="col"
            class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap"
          >
            Nom
          </th>
          <th
            scope="col"
            class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap"
          >
            Email
          </th>
          <th
            scope="col"
            class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap"
          >
            Role
          </th>
          <th
            scope="col"
            class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap text-center"
          >
            Status
          </th>
          <th scope="col" />
          <th
            v-if="userManager"
            scope="col"
            class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap text-center"
          >
            Actions
          </th>
        </tr>
      </thead>
      <tbody>
        <template v-if="users.length > 0">
          <tr
            v-for="tableUser in userByRoleId"
            :key="tableUser.id"
            class="border-b transition duration-300 ease-in-out h-10"
          >
            <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
              {{ tableUser.firstname }}
            </td>
            <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
              {{ tableUser.lastname }}
            </td>
            <td class="whitespace-nowrap overflow-hidden text-ellipsis">
              {{ tableUser.email }}
            </td>
            <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
              {{ getRoleName(tableUser.role_id) }}
            </td>
            <td class="text-center">
              <span :class="{ 'text-green-500': tableUser.clock?.status }">
                ⬤
              </span>
            </td>
            <td class="flex h-full items-center justify-center">
              <svg-icon
                v-if="userInSameTeam(user as IUser, tableUser)"
                name="team"
                class="w-4 h-4"
              />
              <svg-icon
                v-if="userManageable(user as IUser, tableUser)"
                name="settings"
                class="w-4 h-4"
              />
            </td>
            <td v-if="userManager" class="text-center">
              <AppButton
                button-style="tertiary"
                type="button"
                class="btn-icon"
                @click="navigateTo(`/session/users/${tableUser.id}`)"
              >
                <svg-icon name="eye" class="w-4 h-4" />
              </AppButton>
            </td>
          </tr>
        </template>
        <template v-else-if="loading">
          <tr>
            <td colspan="99" class="py-4">
              <div class="flex justify-center">
                <AppSpinner />
              </div>
            </td>
          </tr>
        </template>
        <template v-else>
          <tr>
            <td colspan="99" class="text-center px-6 py-4">Aucune donnée</td>
          </tr>
        </template>
      </tbody>
    </table>
  </section>
</template>

<style scoped></style>
