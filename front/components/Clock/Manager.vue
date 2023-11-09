<script setup lang="ts">
import type { IUser } from "~/utils/user";

const props = defineProps<{
  user: IUser;
  manageable: boolean;
  inLabel: string;
  outLabel: string;
}>();

const getUserClockAPI = useGetClock();
const clockUserAPI = useClockUser();
const emits = defineEmits(["clockOut"]);

const clock = ref<IClock | null>(null);
const time = ref("00:00:00");
const interval = ref();
const formatDate = useFormatDate();
const formatDateLocaleDateTime = useFormatDateTimeLocal();

const calcTimer = () => {
  if (!clock.value) {
    return;
  }
  const clockTime = formatDate(clock.value.time.toString());
  const now = new Date().getTime();
  const timeDifference = now - clockTime.getTime();

  console.log(timeDifference);

  const hours = String(
    Math.floor((timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
  ).padStart(2, "0");
  const minutes = String(
    Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60)),
  ).padStart(2, "0");
  const seconds = String(
    Math.floor((timeDifference % (1000 * 60)) / 1000),
  ).padStart(2, "0");

  time.value = `${hours}:${minutes}:${seconds}`;
};

const clockIn = computed(() => {
  return !clock.value || !clock.value?.status;
});

const clockOut = computed(() => {
  return clock.value && clock.value.status;
});

const clockUser = async () => {
  const response = await clockUserAPI(props.user.id);

  if (!response.ok) {
    return alert("Une erreur est servenue lors du badging");
  }

  clock.value = response.data;

  if (clock.value.status && !interval.value) {
    calcTimer();
    interval.value = setInterval(calcTimer, 1000);
  } else if (interval.value) {
    clearInterval(interval.value);
    interval.value = null;
  }

  if (!clock.value.status) {
    time.value = "00:00:00";
    emits("clockOut");
  }
};

const refresh = async () => {
  const response = await getUserClockAPI(props.user.id);

  if (!response.ok) {
    return;
  }

  clock.value = response.data;

  if (clock.value?.status && !interval.value) {
    calcTimer();
    interval.value = setInterval(calcTimer, 1000);
  }
};

onMounted(async () => {
  await refresh();
});

onUnmounted(() => {
  clearInterval(interval.value);
  interval.value = null;
});
</script>

<template>
  <AppCard class="flex items-center justify-center">
    <div class="space-y-10">
      <div v-if="clock" class="clock-infos min-h-[24px]">
        <span>
          <span v-if="clockOut"> Badgé à: </span>
          <span v-else> Parti à: </span>
          {{
            formatDateLocaleDateTime(formatDate(clock.time))
              .toString()
              .replace("T", " ")
          }}
        </span>
      </div>

      <div class="text-5xl font-bold">
        {{ time }}
      </div>

      <AppButton
        v-if="manageable"
        button-style="secondary"
        type="button"
        class="w-full"
        @click="clockUser"
      >
        <template v-if="clockIn">{{ inLabel }}</template>
        <template v-else-if="clockOut">{{ outLabel }}</template>
      </AppButton>
    </div>
  </AppCard>
</template>

<style scoped></style>
