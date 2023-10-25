<script setup lang="ts">
import type { IUser } from '@/types/user';

defineProps<{
  user: IUser | null
}>()

</script>

<template>
  <div class="user-info">
    <template v-if="user">
      <div>
        Email: {{ user.email }}
      </div>
      <div>
        Username: {{ user.username }}
      </div>
    </template>
    <template v-else>
      <span>Pas de session</span>
    </template>
  </div>

</template>

<style scoped>
.user-info {
  background: darkgray;
}
</style>