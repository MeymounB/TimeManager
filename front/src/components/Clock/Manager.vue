<script setup lang="ts">
import AppCard from "@/components/AppCard.vue";
import { useClockUser, useGetClock } from "@/composables/clock";
import { useSessionStore } from "@/stores/sessionStore";
import { storeToRefs } from "pinia";
import type { IClock } from "@/types/clock";
import { computed, onMounted, ref } from "vue";
import AppButton from "@/components/AppButton.vue";
import { useFormatDate, useFormatDateTimeLocal } from "@/composables/dateFormat.ts";

const { user } = storeToRefs(useSessionStore());
const getUserClockAPI = useGetClock();
const clockUserAPI = useClockUser();
const emits = defineEmits(["clockOut"]);

const clock = ref<IClock | null>(null);
const time = ref("00:00:00");
const interval = ref()
const formatDate = useFormatDate()
const formatDateLocaleDateTime = useFormatDateTimeLocal()
const startDateTime = computed(() => {
  return (clock.value?.time && clock.value.status) ?? null
})

const calcTimer = () => {
  if (!clock.value) {
    return
  }
  const clockTime = formatDate(clock.value.time.toString())
  const now = new Date().getTime();
  const timeDifference = now - clockTime.getTime();

  const hours = String(Math.floor((timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))).padStart(2, '0');
  const minutes = String(Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60))).padStart(2, '0');
  const seconds = String(Math.floor((timeDifference % (1000 * 60)) / 1000)).padStart(2, '0');

  time.value = `${hours}:${minutes}:${seconds}`;
}

const clockIn = computed(() => {
  return !clock.value || !clock.value?.status;
});

const clockOut = computed(() => {
  return clock.value && clock.value.status;
});

const clockUser = async () => {
  if (!user.value) {
    return;
  }

  const response = await clockUserAPI(user.value.id);

  if (!response.ok) {
    return alert("Une erreur est servenue lors du badging");
  }

  clock.value = response.data;

  if (clock.value.status && !interval.value) {
    calcTimer()
    interval.value = setInterval(calcTimer, 1000)
  } else if (interval.value){
    clearInterval(interval.value)
    interval.value = null
  }

  if (!clock.value.status) {
    time.value = "00:00:00"
    emits("clockOut");
  }
};

const refresh = async () => {
  if (!user.value) {
    return;
  }
  const response = await getUserClockAPI(user.value.id);

  if (!response.ok) {
    return;
  }

  clock.value = response.data;

  if (clock.value?.status && !interval.value) {
    calcTimer()
    interval.value = setInterval(calcTimer, 1000)
  }
};

onMounted(async () => {
  await refresh();
});
</script>

<template>
  <section class="manager">
    <AppCard title="Clocks" class="text-center">
      <div class="space-y-10">
        <div class="clock-infos min-h-[24px]" v-if="clock">
          <span>
            <span v-if="clockOut">
              Badgé à:
            </span>
            <span v-else>
              Parti à:
            </span>
            {{ formatDateLocaleDateTime(formatDate(clock.time)).toString().replace('T', ' ') }}
          </span>
        </div>

        <div class="text-5xl font-bold">
          {{ time }}
        </div>

        <AppButton
          button-style="secondary"
          type="button"
          v-if="user"
          @click="clockUser"
          class="w-1/2"
        >
          <template v-if="clockIn"> Me badger </template>
          <template v-else-if="clockOut"> Partir </template>
        </AppButton>
        <template v-else>
          Veuillez vous identifier afin de pouvoir vous badger
        </template>
      </div>

    </AppCard>
  </section>
</template>

<style scoped></style>