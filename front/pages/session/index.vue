<script setup lang="ts">
definePageMeta({
  middleware: ["auth"],
});

const formatChartData = useFormatChartDataWorkingTime();

const session = useSessionStore();
const { user } = storeToRefs(session);

const chartData = computed(() => {
  if (!user.value) {
    return null;
  }
  return formatChartData(
    [{ id: user.value.id, name: user.value.firstname }],
    user.value?.working_times,
  );
});
</script>

<template>
  <section class="dashboard">
    <VueChartLine :chart-data="chartData"></VueChartLine>
  </section>
</template>
