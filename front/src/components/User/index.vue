<script setup lang="ts">
import UserInfo from '@/components/User/Info.vue'
import UserForm from '@/components/User/DynamicForm.vue'
import { useSessionStore } from '@/stores/sessionStore';
import { storeToRefs } from 'pinia';
import AppCard from '@/components/AppCard.vue';
import AppButton from "@/components/AppButton.vue";

const sessionStore = useSessionStore()
const { user } = storeToRefs(sessionStore)

const logout = () => {
  sessionStore.localLogout()
}
</script>

<template>
  <section class="user-container">
    <AppCard title="Utilisateur">
      <div class="space-y-5">
        <UserInfo />
        <UserForm />
        <AppButton type="button" v-if="user" class="w-full" button-style="secondary" @click="logout">
          <span>Se déconnecter</span>
        </AppButton>
        <AppButton type="button" v-if="user" class="w-full" button-style="danger">
            <span class="text-white">Supprimer mon compte</span>
        </AppButton>
      </div>
    </AppCard>
  </section>
</template>

<style scoped>
</style>