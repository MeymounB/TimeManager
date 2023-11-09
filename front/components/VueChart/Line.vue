<script lang="ts" setup>
import { Line } from "vue-chartjs";

defineProps<{
  chartData: { datasets: IDataset[]; labels: string[] };
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
  <div v-if="render" class="h-full">
    <Line :data="chartData" :options="chartOptions" />
  </div>
</template>
