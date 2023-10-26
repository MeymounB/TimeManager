<script setup lang="ts">
import type { IUser } from '@/types/user';
import AppButton from '@/components/AppButton.vue';

const props = defineProps<{
  user: IUser | null
}>()

const onSubmit = () => {
  if (!props.user) {
    // créer
  }  else {
    // editer
  }
}
</script>

<template>
  <section class="user-form">
    <form @submit.prevent="" >
      <div class="space-y-2">
        <div class="input-section">
          <label class="font-semibold">Email</label>
          <input type="text" class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg" placeholder="email@box.com">
        </div>
        <div class="input-section">
          <label class="font-semibold">Username</label>
          <input type="text" class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg" placeholder="fancy123">
        </div>
      </div>

      <AppButton type="submit" class="mt-5">
        <template v-if="user">
          <span>Éditer</span>
        </template>
        <template v-else>
          <span>Créer</span>
        </template>
      </AppButton>
    </form>
  </section>
</template>

<style scoped>
.user-form {
  .input-section {
    display: flex;
    flex-direction: column;
  }
}
</style>