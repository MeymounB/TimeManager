<script setup lang="ts">
</script>

<template>
  <section class="demo">
    <div class="section">
	<div class="flex-column text-justify">
		<p class="m-4">Voici une démonstration de ce que peut réaliser notre application Time Manager.</p>
		<p class="m-4">Ici vous utilisez les données que l'API envoie.</p>
	</div>
	<ChartManager class="w-full" />
    </div>
  </section>
</template>
<style scoped>
.demo {
  padding: 32px;
  .section {
    width: 100%;
    height: 50%;
    display: flex;
    margin-bottom: 10px;
    gap: 8px;
  }
}
</style>
