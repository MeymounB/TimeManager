<script setup lang="ts">
import AppCard from '@/components/AppCard.vue';
import { useClockUser, useGetClock } from '@/composables/clock';
import { useSessionStore } from '@/stores/sessionStore';
import { storeToRefs } from 'pinia';
import type { IClock } from '@/types/clock';
import { computed, onMounted, ref } from 'vue';
import AppButton from '@/components/AppButton.vue';

const { user } = storeToRefs(useSessionStore())
const getUserClockAPI = useGetClock()
const clockUserAPI = useClockUser()

const clock = ref<IClock | null>(null)

const clockIn = computed(() => {
  return !clock.value || !clock.value?.status
})

const clockOut = computed(() => {
  return clock.value && clock.value.status
})

const clockUser = async () => {
  if (!user.value) {
    return
  }
  const response = await clockUserAPI(user.value.id)

  if (!response.ok) {
    return alert('Une erreur est servenue lors du badging')
  }

  clock.value = response.data
}

const updateClock = async () => {
  if (!user.value) {
    return
  }
  const response = await getUserClockAPI(user.value.id)

  if (!response.ok) {
    return
  }

  clock.value = response.data
}


onMounted(async () => {
  await updateClock()
})
</script>

<template>
  <section class="manager">
    <AppCard title="Clocks">
      <div class="clock-infos" v-if="clock">
        <span>Badgé à: {{ clock.time }}</span>
      </div>

      <AppButton type="button" v-if="user">
        <template v-if="clockIn">
          Me badger
        </template>
        <template v-else-if="clockOut">
          Partir
        </template>
      </AppButton>
      <template v-else>
        Veuillez vous identifier afin de pouvoir vous badger
      </template>
    </AppCard>
  </section>
</template>

<style scoped>
</style>