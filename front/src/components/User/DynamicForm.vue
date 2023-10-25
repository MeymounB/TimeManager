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
    <form @submit.prevent="">
      <div class="input-section">
        <label>Email</label>
        <input type="text" placeholder="email@box.com">
      </div>
      <div class="input-section">
        <label>Username</label>
        <input type="text" placeholder="fancy123">
      </div>

      <AppButton type="submit">
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

    label {
      margin-bottom: 10px;
    }
  }
}
</style>