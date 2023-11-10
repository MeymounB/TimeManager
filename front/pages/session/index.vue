<script setup lang="ts">
import type { IUser } from "~/utils/user";
import { VueChartBar } from "#components";

definePageMeta({
  middleware: ["auth"],
});

const formatChartData = useFormatChartDataWorkingTime();
const formatWTTime = useFormatWorkingTimeToTime();

const session = useSessionStore();
const { user } = storeToRefs(session);

const chartData = computed(() => {
  if (!user.value) {
    return null;
  }
  return formatChartData(
    [{ id: user.value.id, name: user.value.firstname }],
    formatWTTime(user.value?.working_times),
  );
});

const chart1 = ref<InstanceType<typeof VueChartBar> | null>();

const onClockOut = () => {
  chart1.value.reRender(() => {
    if (!user.value) {
      return;
    }
    session.reloadUser();
  });
};
</script>

<template>
  <section v-if="user" class="mt-5 px-1 md:px-5">
    <div class="grid grid-cols-1 gap-5 md:grid-cols-2 h-[400px]">
      <h1 class="font-bold italic text-center self-center leading-10">
        <span class="text-6xl lg:text-8xl">Bonjour,</span><br />
        <span class="md:mt-0 text-4xl lg:text-6xl text-blue-800 self-end">
          {{ user.firstname }}
          {{ user.lastname }}
        </span>
      </h1>

      <ClockManager
        :user="user as IUser"
        :manageable="true"
        in-label="Commencer"
        out-label="Partir"
        @clock-out="onClockOut"
      />
    </div>
    <AppCard class="mt-10 text-center">
      <span class="font-bold text-xl">Votre temps de travail</span>
      <VueChartLine ref="chart1" class="h-[400px]" :chart-data="chartData" />
    </AppCard>
  </section>
</template>
