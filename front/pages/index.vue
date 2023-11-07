<script setup lang="ts">
definePageMeta({
  middleware: ["guest"],
});
</script>

<template>
  <section class="flex flex-col min-h-screen w-full">
    <HomeHeroSection />
    <HomeAboutSection />
    <HomeUserBenefitsSection />
    <HomeFeaturesDetailSection />
    <HomeChartsDemoSection />
    <HomeAccessibilitySection />
  </section>
</template>

<style scoped></style>
