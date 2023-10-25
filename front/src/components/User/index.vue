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
      <UserInfo :user="user" />
      <UserForm :user="user" />
    </AppCard>
  </section>
</template>

<style scoped>
</style>