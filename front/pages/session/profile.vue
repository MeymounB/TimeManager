<script setup lang="ts">
import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";
import type { IUser } from "~/utils/user";

definePageMeta({
  middleware: ["auth"],
});

const session = useSessionStore();
const { user } = storeToRefs(session);
const updateAccountAPI = useUpdateAccount();

const formValue = reactive({
  firstname: user.value?.firstname,
  lastname: user.value?.lastname,
  email: user.value?.email,
  role_id: user.value?.role_id,
});

const onSubmit = async () => {
  if (!user.value) {
    return;
  }

  const toSubmit = {
    ...(formValue.email !== user.value.email ? { email: formValue.email } : {}),
    ...(formValue.firstname !== user.value.firstname
      ? { firstname: formValue.firstname }
      : {}),
    ...(formValue.lastname !== user.value.lastname
      ? { lastname: formValue.lastname }
      : {}),
  };

  const response = await updateAccountAPI(toSubmit);

  if (!response.ok) {
    return alert("Error happened while updating profile");
  }

  await session.reloadUser();
};
</script>

<template>
  <section
    v-if="user"
    class="profile mx-auto bg-white shadow-md rounded-lg max-w-7xl mt-0 md:mt-6"
  >
    <div class="text-center py-6 bg-gray-100 border-b">
      <h1 class="text-3xl font-bold text-gray-800">Votre Profil</h1>
      <p class="text-gray-600">
        Vous pouvez mettre à jour vos informations ci-dessous.
      </p>
    </div>
    <div class="p-4 sm:-6">
      <UserForm
        v-model="formValue"
        :true-user="user as IUser"
        @submit="onSubmit"
      />
      <div class="grid grid-cols-2 divide-x gap-5">
        <div class="p-3">
          <span class="block font-medium">Mes équipes</span>
          <div
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 mt-5"
          >
            <div
              v-for="team in user.teams"
              :key="team.id"
              class="flex items-center gap-3 border border-gray-700 rounded max-w-[200px] px-4 py-2"
            >
              <svg-icon name="team" class="w-5 h-5" />
              <span
                class="font-medium text-center text-sm whitespace-nowrap text-ellipsis overflow-hidden"
                >{{ team.name }}</span
              >
            </div>
          </div>
        </div>

        <div class="p-3">
          <span class="block font-medium">Équipes gérées</span>
          <div
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 mt-5"
          >
            <div
              v-for="team in user.managed_teams"
              :key="team.id"
              class="flex items-center gap-3 border border-gray-700 rounded max-w-[200px] px-4 py-2"
            >
              <svg-icon name="team" class="w-5 h-5" />
              <span
                class="font-medium text-center text-sm whitespace-nowrap text-ellipsis overflow-hidden"
                >{{ team.name }}</span
              >
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped></style>
