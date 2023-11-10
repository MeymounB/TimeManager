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
  return formatChartData([user.value], user.value?.working_times);
});
</script>

<template>
  <section class="dashboard">
    <VueChartLine :chart-data="chartData"></VueChartLine>
  </section>
</template>
<style scoped>
.dashboard {
  .section {
    width: 100%;
    height: 50%;
    display: flex;
    margin-bottom: 10px;
    gap: 8px;
  }
}
</style>
