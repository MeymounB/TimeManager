<script setup lang="ts">
import { storeToRefs } from "pinia";
import type { IRole } from "~/utils/roles";
import type { IUserShort } from "~/utils/user";
import { isUserAdmin, isUserManager } from "~/composables/user";
import { useSessionStore } from "~/stores/sessionStore";

definePageMeta({
  middleware: ["auth"],
});

const session = useSessionStore();
const { user } = storeToRefs(session);
const getAllUser = useGetAllUser();
const getAllRoles = useGetAllRoles();
// const formatDate = useFormatDate();
// const formatDateTimeLocal = useFormatDateTimeLocal();
const users = ref<IUserShort[]>([]);
const roles = ref<IRole[]>([]);

const fetchAllUsers = async () => {
  const response = await getAllUser();

  if (!response.ok) {
    return alert("Error happened while fetching");
  }

  users.value = response.data;
};

const userByRoleId = computed(() => {
  return users.value.sort((prev: IUserShort, next: IUserShort) => {
    return prev.role_id - next.role_id;
  });
});

const userAdmin = computed(() => {
  return isUserAdmin(user.value as IUser);
});

const userGeneralManager = computed(() => {
  return isUserManager(user.value as IUser);
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
  <section class="users">
    <table class="w-3/5 h-1/2 text-left text-sm font-light">
      <thead class="border-b font-medium dark:border-neutral-500">
        <tr>
          <th scope="col" class="px-6 py-4">Prénom</th>
          <th scope="col" class="px-6 py-4">Nom</th>
          <th scope="col" class="px-6 py-4">Email</th>
          <th scope="col" class="px-6 py-4">Role</th>
          <th v-if="userManager" scope="col" class="px-6 py-4 text-center">
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
            <td>{{ tableUser.firstname }}</td>
            <td>{{ tableUser.lastname }}</td>
            <td>{{ tableUser.email }}</td>
            <td>{{ getRoleName(tableUser.role_id) }}</td>
            <td v-if="userManager" class="text-center">
              <AppButton button-style="tertiary" type="button" class="btn-icon">
                <svg-icon name="eye" class="w-4 h-4" />
              </AppButton>
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
