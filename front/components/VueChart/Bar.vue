<script lang="ts" setup>
import { Bar } from "vue-chartjs";
import type { IChartData } from "~/utils/chart";

defineProps<{
  chartData: IChartData | null;
}>();

const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
});

const render = ref(true);

const reRender = (fn: Function) => {
  render.value = false;
  setTimeout(() => {
    fn();
    render.value = true;
  }, 0);
};

defineExpose({
  reRender,
});
</script>
<template>
  <div v-if="render && chartData" class="h-full">
    <Bar :data="chartData" :options="chartOptions" />
  </div>
  <template v-else>
    <div class="w-full flex justify-center">
      <AppSpinner />
    </div>
  </template>
</template>
