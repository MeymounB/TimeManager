<script setup lang="ts">
import AppCard from '@/components/AppCard.vue';
import { useGetAllWorkingTimes } from '@/composables/working-times';
import { onMounted, ref } from 'vue';
import type { IWorkingTime } from '@/types/workingTime';

const getWorkingTimesAPI = useGetAllWorkingTimes()
const workingTimes = ref<IWorkingTime[]>([])

const updateWorkingTimes = async () => {
  const response = await getWorkingTimesAPI()

  if (!response.ok) {
    return
  }

  workingTimes.value = response.data
}

onMounted(async () => {
  await updateWorkingTimes()
})

defineExpose({
  updateWorkingTimes,
})
</script>

<template>
  <section class="working-times-container">
    <AppCard title="Working times">
      <table class="working-times-table table-auto">
        <thead>
        <tr>
          <th>Début</th>
          <th>Fin</th>
          <th>User ID</th>
        </tr>
        </thead>
        <tbody>
        <template v-if="workingTimes.length > 0">
          <tr v-for="workingTime in workingTimes" :key="workingTime.id">
            <td>{{workingTime.start.toLocaleDateString}}</td>
            <td>{{workingTime.end.toLocaleDateString}}</td>
            <td>{{workingTime.user_id}}</td>
          </tr>
        </template>
        </tbody>
      </table>
    </AppCard>
  </section>
</template>

<style scoped>
.working-times-container {
  .working-times-table {
    width: 100%;
  }
}
</style>