<script setup lang="ts">
import { WorkingTimes } from "#components";

definePageMeta({
  middleware: ["auth"],
});

const session = useSessionStore();
const { user } = storeToRefs(session);


const workingTimes = ref<IWorkingTime[]>([]);
const accountWorkingTimesAPI = useAccountWorkingTimes();

const updateWorkingTimes = async () => {
  const response = await accountWorkingTimesAPI();
  if (!response.ok) {
    console.error('Failed to fetch user working times data');
    return;
  }
  workingTimes.value = response.data;
};

onMounted(async () => {
  updateWorkingTimes();
});
</script>

<template>
  <section class="dashboard">Oui</section>
  <ChartUserWTChart :user="(user as IUser)" :workingTimes="workingTimes"/>
  <!--  <section class="dashboard">-->
  <!--    <div class="section">-->
  <!--      <User class="w-full" />-->
  <!--      <ClockManager class="w-full" @clock-out="updateWorkingTimes" />-->
  <!--    </div>-->
  <!--    <div class="section">-->
  <!--      <ChartManager class="w-full" />-->
  <!--    </div>-->
  <!--    <div class="section">-->
  <!--      <WorkingTimes ref="workingTimes" class="w-full" />-->
  <!--    </div>-->
  <!--  </section>-->
</template>
<style scoped>
.dashboard {
  .section {
    width: 100%;
    height: 50%;
    display: flex;
    margin-bottom: 10px;
    gap: 8px;
  }
}
</style>
