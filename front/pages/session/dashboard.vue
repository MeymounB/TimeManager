<script setup lang="ts">
import { WorkingTimes } from "#components";

definePageMeta({
  middleware: ["auth"],
});

const workingTimes = ref<InstanceType<typeof WorkingTimes> | null>(null);
const updateWorkingTimes = () => {
  workingTimes.value?.updateWorkingTimes();
};
</script>

<template>
  <section class="dashboard">
    <div class="section">
      <User class="w-full" />
      <ClockManager class="w-full" @clock-out="updateWorkingTimes" />
    </div>
    <div class="section">
      <ChartManager class="w-full" />
    </div>
    <div class="section">
      <WorkingTimes ref="workingTimes" class="w-full" />
    </div>
  </section>
</template>
<style scoped>
.dashboard {
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
