<template>
  <div>
    <canvas id="custom-multi-axis-line-chart-canvas" ref="chart" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { Chart, LineController, LineElement, PointElement, LinearScale, Title, CategoryScale } from 'chart.js';

Chart.register(LineController, LineElement, PointElement, LinearScale, Title, CategoryScale);

const chart = ref(null);
const workingTimes = ref([]);

const colors = [
    '#FF6384', '#36A2EB', '#FFCE56', '#AA6384', '#2CA21B', '#FD6A02',
    '#965AA2', '#D982B5', '#2C3E50', '#3498DB', '#F39C12', '#16A085',
    '#2980B9', '#D35400', '#8E44AD', '#27AE60', '#C0392B', '#7D3C98',
    '#2E4053', '#1ABC9C', '#5499C7', '#AF7AC5', '#48C9B0', '#A569BD',
    '#45B39D', '#7D3C98', '#D5DBDB', '#283747', '#1B4F72', '#641E16'
];

const fetchData = async () => {
  const response = await fetch('/data.json');
  if (!response.ok) {
    console.error('Failed to fetch data:', response.statusText);
    return;
  }
  workingTimes.value = await response.json();
};

const updateChart = () => {
  const uniqueDates = Array.from(
    new Set(workingTimes.value.map(item => new Date(item.start).toLocaleDateString()))
  );

  const groupedData = workingTimes.value.reduce((acc, item) => {
    const startDate = new Date(item.start);
    const endDate = new Date(item.end);
    const duration = (endDate.getTime() - startDate.getTime()) / (1000 * 60);
    const date = new Date(item.start).toLocaleDateString();
    const dateIndex = uniqueDates.indexOf(date);

    if (!acc[item.name]) {
      acc[item.name] = Array(uniqueDates.length).fill(null);
    }

    acc[item.name][dateIndex] = duration;

    return acc;
  }, {});

  const datasets = Object.keys(groupedData).map((userName, index) => ({
    label: userName,
    data: groupedData[userName],
    yAxisID: 'y1',
    backgroundColor: colors[index % colors.length],
    borderColor: colors[index % colors.length],
    fill: false,
  }));

  const maxDuration = Math.max(...Object.values(groupedData).flat());

  const options = {
    scales: {
      x: {
        type: 'category',
        labels: uniqueDates,
      },
      y1: {
        type: 'linear',
        position: 'left',
        max: maxDuration,
        min: 0,
      },
    },
  };

  // @ts-ignore
  chart.value = new Chart(
    document.getElementById('custom-multi-axis-line-chart-canvas'),
    {
      type: 'line',
      data: {
        labels: uniqueDates,
        datasets,
      },
      options,
    }
  );
};

onMounted(async () => {
  await fetchData();
  updateChart();
});
</script>
