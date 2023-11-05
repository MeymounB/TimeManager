<template>
  <div>
    <canvas id="stacked-bar-chart-canvas" ref="chart" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { Chart, registerables } from 'chart.js';
import { useGetAllWorkingTimes } from '@/composables/working-times';
import type { IWorkingTime } from '@/types/workingTime';

Chart.register(...registerables);

const workingTimes = ref<IWorkingTime[]>([]);
const uniqueDates = ref<string[]>([]);
const chart = ref(null);

const colors = [
    '#FF6384', '#36A2EB', '#FFCE56', '#AA6384', '#2CA21B', '#FD6A02',
    '#965AA2', '#D982B5', '#2C3E50', '#3498DB', '#F39C12', '#16A085',
    '#2980B9', '#D35400', '#8E44AD', '#27AE60', '#C0392B', '#7D3C98',
    '#2E4053', '#1ABC9C', '#5499C7', '#AF7AC5', '#48C9B0', '#A569BD',
    '#45B39D', '#7D3C98', '#D5DBDB', '#283747', '#1B4F72', '#641E16'
];

const updateWorkingTimes = async () => {
  const getWorkingTimesAPI = useGetAllWorkingTimes();
  const response = await getWorkingTimesAPI();

  if (!response.ok) {
    return;
  }

  workingTimes.value = response.data;

  const dateSet = new Set(workingTimes.value.map(workingTime => {
    return new Date(workingTime.start).toLocaleDateString();
  }));
  uniqueDates.value = [...dateSet];

  const groupedData = workingTimes.value.reduce((acc, workingTime) => {
    const dateIndex = uniqueDates.value.indexOf(new Date(workingTime.start).toLocaleDateString());
    const duration = (new Date(workingTime.end).getTime() - new Date(workingTime.start).getTime()) / (1000 * 60);

    if (!acc[workingTime.user_id]) {
      acc[workingTime.user_id] = Array(uniqueDates.value.length).fill(0);
    }

    acc[workingTime.user_id][dateIndex] += duration;

    return acc;
  }, {});

  const datasets = Object.keys(groupedData).map((userId, index) => ({
    label: `User ${userId}`,
    data: groupedData[userId],
    backgroundColor: colors[index % colors.length],  // Utiliser la couleur de fond
    borderColor: colors[index % colors.length],  // Utiliser la couleur de la bordure
    borderWidth: 1,
    stack: `User ${userId}`
  }));

  const ctx = document.getElementById('stacked-bar-chart-canvas') as HTMLCanvasElement;
  // @ts-ignore
  chart.value = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: uniqueDates.value,
      datasets: datasets
    },
    options: {
      scales: {
        x: {
          stacked: true,
        },
        y: {
          stacked: true
        }
      }
    }
  });
};

onMounted(async () => {
  await updateWorkingTimes();
});
</script>