

<script setup lang="ts">
import { ref } from 'vue';
import type { IWorkingTime } from '~/utils/workingTime';
import type { IUser } from '~/utils/user';

const props = defineProps<{
  user: IUser;
  workingTimes: IWorkingTime[];
}>();

const labels = ref<{[objectId: number]: string}>({})
const times = ref<ITime[]>([])

watchEffect(() => {
  labels.value = {}
  labels.value[props.user.id] = props.user.firstname

  times.value = props.workingTimes.map((workingTime) => {
    return {
      date: new Date(workingTime.start).toLocaleDateString(), 
      duration: (new Date(workingTime.end).getTime() - new Date(workingTime.start).getTime()) / (1000 * 3600),
      objectId: workingTime.user_id
    }
  })
});
</script>

<template>
  <ChartTimeChart :labels="labels" :times="times" :type="'bar'"/>
</template>
