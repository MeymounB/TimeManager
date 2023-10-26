<script setup lang="ts">
import AppCard from '@/components/AppCard.vue';
import { useGetAllWorkingTimes } from '@/composables/working-times';
import { onMounted, ref } from 'vue';
import type { IWorkingTime } from '@/types/workingTime';
import { useFormatDate, useFormatDateTimeLocal } from "@/composables/dateFormat.ts";
import WorkingTime from "@/components/WorkingTime.vue";

const getWorkingTimesAPI = useGetAllWorkingTimes()
const workingTimes = ref<IWorkingTime[]>([])
const formatDate = useFormatDate()
const formatDateTimeLocal = useFormatDateTimeLocal()
const selectedWT = ref<IWorkingTime | undefined>()

const getWorkingTimes = async () => {
  const response = await getWorkingTimesAPI()

  if (!response.ok) {
    return
  }

  workingTimes.value = response.data
  selectedWT.value = undefined
}

const onWTSelect = (workingTime: IWorkingTime) => {
  if (selectedWT.value && selectedWT.value.id === workingTime.id) {
    selectedWT.value = undefined
  } else {
    selectedWT.value = workingTime
  }
}

onMounted(async () => {
  await getWorkingTimes()
})

defineExpose({
  updateWorkingTimes: getWorkingTimes,
})
</script>

<template>
  <section class="working-times-container">
    <AppCard title="Working times">
      <div class="flex flex-row justify-between h-full">
        <table class="w-3/5 h-1/2 text-left text-sm font-light">
          <thead class="border-b font-medium dark:border-neutral-500">
          <tr>
            <th scope="col" class="px-6 py-4">Début</th>
            <th scope="col" class="px-6 py-4">Fin</th>
            <th scope="col" class="px-6 py-4">User ID</th>
          </tr>
          </thead>
          <tbody>
          <template v-if="workingTimes.length > 0">
            <tr v-for="workingTime in workingTimes" @click="onWTSelect(workingTime)" class="border-b transition duration-300 ease-in-out cursor-pointer h-20" :class="{ 'bg-blue-300': selectedWT?.id === workingTime.id}">
              <td class="whitespace-nowrap px-6 py-4">{{ formatDateTimeLocal(formatDate(workingTime.start)).toString().replace('T', ' ') }}</td>
              <td class="whitespace-nowrap px-6 py-4">{{ formatDateTimeLocal(formatDate(workingTime.end)).toString().replace('T', ' ') }}</td>
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
        <WorkingTime v-model="selectedWT" @update-all="getWorkingTimes" class="w-1/3 h-1/2" />
      </div>

    </AppCard>
  </section>
</template>

<style scoped>
.working-times-container {
  min-height: 70%;
  .working-times-table {
    width: 100%;
  }
}
</style>