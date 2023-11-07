<script setup lang="ts">
import type { IWorkingTime } from "~/utils/workingTime";

definePageMeta({
  middleware: ["auth"],
});

const getMyWorkingTimesAPI = useAccountWorkingTimes();
const workingTimes = ref<IWorkingTime[]>([]);
const formatDateTimeLocal = useFormatDateTimeLocal();
const formatDate = useFormatDate();

onMounted(async () => {
  const response = await getMyWorkingTimesAPI();

  if (!response.ok) {
    return alert("An error happened while fetching");
  }

  workingTimes.value = response.data;
});
</script>

<template>
  <section>
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
          <tr
            v-for="workingTime in workingTimes"
            :key="workingTime.id"
            class="border-b transition duration-300 ease-in-out cursor-pointer h-10"
          >
            <td class="whitespace-nowrap px-6 py-4">
              {{
                formatDateTimeLocal(formatDate(workingTime.start))
                  .toString()
                  .replace("T", " ")
              }}
            </td>
            <td class="whitespace-nowrap px-6 py-4">
              {{
                formatDateTimeLocal(formatDate(workingTime.end))
                  .toString()
                  .replace("T", " ")
              }}
            </td>
            <td class="whitespace-nowrap px-6 py-4">
              {{ workingTime.user_id }}
            </td>
          </tr>
        </template>
        <template v-else>
          <tr>
            <td colspan="99" class="text-center px-6 py-4">Aucune donnée</td>
          </tr>
        </template>
      </tbody>
    </table>
  </section>
</template>

<style scoped></style>
