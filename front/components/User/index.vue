<script setup lang="ts">
import { storeToRefs } from "pinia";
import { useSessionStore } from "@/stores/sessionStore";

const sessionStore = useSessionStore();
const { user } = storeToRefs(sessionStore);
const deleteUserAPI = useDeleteUser();

const logout = () => {
  sessionStore.localLogout();
};

const deleteUser = async () => {
  if (!user.value) {
    return;
  }
  const response = await deleteUserAPI(user.value.id);

  if (!response.ok) {
    return alert("Une erreur est survenue");
  }

  logout();
};
</script>

<template>
  <section class="user-container">
    <AppCard title="Utilisateur">
      <div class="space-y-5">
        <UserInfo />
        <UserDynamicForm />
        <AppButton
          v-if="user"
          type="button"
          class="w-full"
          button-style="secondary"
          @click="logout"
        >
          <span>Se déconnecter</span>
        </AppButton>
        <AppButton
          v-if="user"
          type="button"
          class="w-full"
          button-style="danger"
          @click="deleteUser"
        >
          <span class="text-white">Supprimer mon compte</span>
        </AppButton>
      </div>
    </AppCard>
  </section>
</template>

<style scoped></style>
