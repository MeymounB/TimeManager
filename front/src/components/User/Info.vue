<script setup lang="ts">
import { storeToRefs } from "pinia";
import { useSessionStore } from "@/stores/sessionStore.ts";

const { user } = storeToRefs(useSessionStore())
</script>

<template>
  <div class="user-info text-center">
    <template v-if="user">
      <div class="text-3xl">
        {{ user.username }}
      </div>
      <div class="text-xs">
        {{ user.email }}
      </div>
    </template>
    <template v-else>
      <span>Pas de session</span>
    </template>
  </div>

</template>
