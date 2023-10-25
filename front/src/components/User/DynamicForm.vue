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
      <div>
        <label>Email</label>
        <input>
      </div>
      <div>
        <label>Username</label>
        <input>
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

</style>