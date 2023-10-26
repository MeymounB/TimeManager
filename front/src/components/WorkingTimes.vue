<script setup lang="ts">
import AppCard from '@/components/AppCard.vue';
import { useGetAllWorkingTimes } from '@/composables/working-times';
import { onMounted, ref } from 'vue';
import type { IWorkingTime } from '@/types/workingTime';
import { useFormatDate } from "@/composables/dateFormat.ts";

const getWorkingTimesAPI = useGetAllWorkingTimes()
const workingTimes = ref<IWorkingTime[]>([])
const formatDate = useFormatDate()

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
      <table class="min-w-full text-left text-sm font-light">
        <thead class="border-b font-medium dark:border-neutral-500">
        <tr>
          <th scope="col" class="px-6 py-4">Début</th>
          <th scope="col" class="px-6 py-4">Fin</th>
          <th scope="col" class="px-6 py-4">User ID</th>
        </tr>
        </thead>
        <tbody>
        <template v-if="workingTimes.length > 0">
          <tr v-for="workingTime in workingTimes" class="border-b transition duration-300 ease-in-out hover:bg-neutral-100">
            <td class="whitespace-nowrap px-6 py-4">{{ formatDate(workingTime.start).toLocaleString() }}</td>
            <td class="whitespace-nowrap px-6 py-4">{{ formatDate(workingTime.end).toLocaleString() }}</td>
            <td class="whitespace-nowrap px-6 py-4">{{ workingTime.user_id }}</td>
          </tr>
        </template>
        <template v-else>
          <tr>
            <td colspan="99" class="text-center px-6 py-4">Aucune donnée</td>
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