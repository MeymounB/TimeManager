<script setup lang="ts">
import UserCard from '@/components/User/index.vue'
import ClockCard from '@/components/Clock/Manager.vue'
import WorkingTimesCard from '@/components/WorkingTimes.vue'
import ChartManagerCard from '@/components/Chart/Manager.vue'

import { ref } from "vue";
import WorkingTime from "@/components/WorkingTime.vue";

const workingTimes = ref<InstanceType<typeof WorkingTimesCard> | null>(null)

const updateWorkingTimes = () => {
  workingTimes.value?.updateWorkingTimes()
}
</script>

<template>
  <section class="dashboard">
    <div class="section">
      <UserCard class="w-full" />
      <ClockCard @clock-out="updateWorkingTimes" class="w-full" />
    </div>
    <div class="section">
      <WorkingTimesCard class="w-2/3" ref="workingTimes" />
      <WorkingTime class="w-1/3"></WorkingTime>
    </div>
    <div class="section">
      <ChartManagerCard class="w-full" />
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
