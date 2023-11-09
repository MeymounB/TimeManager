

<script setup lang="ts">
import { ref } from 'vue';
import { Chart, registerables } from 'chart.js';

Chart.register(...registerables);


interface IGroupedData {
  [user_id: number]: {
    [dateIndex: number] : number
  }
}

const props = defineProps<{
  labels: {[objectId: number] : string}
  times: ITime[]
  type: 'bar' | 'pie'
}>();

const colors = [
    '#FF6384', '#36A2EB', '#FFCE56', '#AA6384', '#2CA21B', '#FD6A02',
    '#965AA2', '#D982B5', '#2C3E50', '#3498DB', '#F39C12', '#16A085',
    '#2980B9', '#D35400', '#8E44AD', '#27AE60', '#C0392B', '#7D3C98',
    '#2E4053', '#1ABC9C', '#5499C7', '#AF7AC5', '#48C9B0', '#A569BD',
    '#45B39D', '#7D3C98', '#D5DBDB', '#283747', '#1B4F72', '#641E16'
];
const uniqueDates = ref<string[]>([]);
const chart = ref(null);

watchEffect(() => {
  const dateSet = new Set(props.times.map(time => {
    return time.date;
  }));
  uniqueDates.value = [...dateSet];

  const groupedData = props.times.reduce((acc: IGroupedData, time: ITime) => {
    const dateIndex = uniqueDates.value.indexOf(time.date);

    if (!acc[time.objectId])
      acc[time.objectId] = Array(uniqueDates.value.length).fill(0);

    acc[time.objectId][dateIndex] += time.duration;

    return acc;
  }, {});

  const datasets = Object.keys(groupedData).map((objectId, index) => ({  
    label: props.labels[objectId as any] ?? "Unknown",  
    data: groupedData[objectId as any],
    backgroundColor: colors[index % colors.length],
    borderColor: colors[index % colors.length],
    borderWidth: 1,
    stack: objectId 
  }));

  const ctx = document.getElementById('custom-stacked-bar-chart-canvas') as HTMLCanvasElement;
  // @ts-ignore
  chart.value = new Chart(ctx, {
    type: props.type,
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
});
</script>

<template>
  <div>
    <canvas id="custom-stacked-bar-chart-canvas" ref="chart" />
  </div>
</template>
