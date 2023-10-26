<script setup lang="ts">
import UserInfo from '@/components/User/Info.vue'
import UserForm from '@/components/User/DynamicForm.vue'
import { useSessionStore } from '@/stores/sessionStore';
import { storeToRefs } from 'pinia';
import AppCard from '@/components/AppCard.vue';

const { user } = storeToRefs(useSessionStore())
</script>

<template>
  <section class="user-container">
    <AppCard title="Utilisateurs">
      <div class="space-y-5">
        <UserInfo :user="user" />
        <UserForm :user="user" />
      </div>
    </AppCard>
  </section>
</template>

<style scoped>
</style>