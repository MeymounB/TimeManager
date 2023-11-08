<template>
  <section class="charts-demo-section bg-white py-12">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
      <h2 class="text-center text-2xl sm:text-3xl font-extrabold text-gray-900 mb-8">
        Démonstration des Graphiques
      </h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <!-- Graphique 1 -->
        <div class="chart-card p-4 shadow rounded-lg">
          <h3 class="font-semibold text-lg text-gray-900 mb-3">
            Répartition des Heures de Travail
          </h3>
          
          <ChartCustomPieChart />
        </div>

        <!-- Graphique 2 -->
        <div class="chart-card p-4 shadow rounded-lg">
          <h3 class="font-semibold text-lg text-gray-900 mb-3">
            Répartition des Heures de Travail2
          </h3>
	  <ChartCustomStackedBarChart />
        </div>
      </div>

 	<!-- Graphique 1 -->
        <div class="chart-card p-4 shadow rounded-lg">
          <h3 class="font-semibold text-lg text-gray-900 mb-3">
            Répartition des Heures de Travail3
          </h3>
          
          <ChartCustomMultiAxisLineChart />
        </div>

    </div>
  </section>
</template>

<script setup>
</script>

<style scoped>
.chart-card {
}
</style>
