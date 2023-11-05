<template>
  <div>
    <canvas id="pie-chart-canvas" ref="chart" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { Chart, registerables } from 'chart.js';
import type { IWorkingTime } from '@/types/workingTime';
import { useGetAllWorkingTimes } from '@/composables/working-times';

Chart.register(...registerables);

const workingTimes = ref<IWorkingTime[]>([]);

const updateWorkingTimes = async () => {
  const getWorkingTimesAPI = useGetAllWorkingTimes();
  const response = await getWorkingTimesAPI();

  if (!response.ok) {
    return;
  }

  workingTimes.value = response.data;

  const totalDurationPerUser = workingTimes.value.reduce((acc, workingTime) => {
    const duration = (new Date(workingTime.end).getTime() - new Date(workingTime.start).getTime()) / (1000 * 60);
    if (!acc[workingTime.user_id]) {
      acc[workingTime.user_id] = 0;
    }
    acc[workingTime.user_id] += duration;
    return acc;
  }, {});

  const labels = Object.keys(totalDurationPerUser).map(userId => `User ${userId}`);
  const data = Object.values(totalDurationPerUser);

const colors = [
    '#FF6384', '#36A2EB', '#FFCE56', '#AA6384', '#2CA21B', '#FD6A02',
    '#965AA2', '#D982B5', '#2C3E50', '#3498DB', '#F39C12', '#16A085',
    '#2980B9', '#D35400', '#8E44AD', '#27AE60', '#C0392B', '#7D3C98',
    '#2E4053', '#1ABC9C', '#5499C7', '#AF7AC5', '#48C9B0', '#A569BD',
    '#45B39D', '#7D3C98', '#D5DBDB', '#283747', '#1B4F72', '#641E16'
];

  const ctx = document.getElementById('pie-chart-canvas') as HTMLCanvasElement;
  new Chart(ctx, {
    type: 'pie',
    data: {
      labels: labels,
      datasets: [{
        data: data,
        backgroundColor: colors, 
      }]
    },
  });
};

onMounted(async () => {
  await updateWorkingTimes();
});

</script>