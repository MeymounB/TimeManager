<script setup lang="ts">
import UserCard from '@/components/User/index.vue'
import ClockCard from '@/components/Clock/Manager.vue'
import WorkingTimesCard from '@/components/WorkingTimes.vue'
</script>

<template>
  <section class="dashboard">
    <div class="top-section">
      <UserCard class="user-card" />
      <ClockCard class="clock-card" />
    </div>
    <div class="bottom-section">
      <WorkingTimesCard />
    </div>
  </section>
</template>
<style scoped>
.dashboard {
  padding: 32px;
  .top-section {
    width: 100%;
    height: 40%;
    display: flex;
    margin-bottom: 10px;
    gap: 8px;
  }
  .user-card {
    width: 100%;
  }

  .clock-card {
    width: 100%;
  }

  .bottom-section {
    width: 100%;
    height: 60%;
  }
}
</style>
