<script setup lang="ts">
import { IWorkingTime } from "@/types/workingTime.ts";
import AppButton from "@/components/AppButton.vue";
import { computed, ref, watch } from "vue";
import { useSessionStore } from "@/stores/sessionStore.ts";
import { storeToRefs } from "pinia";
import AppCard from "@/components/AppCard.vue";
import { useFormatDate, useFormatDateTimeLocal } from "@/composables/dateFormat.ts";
import { useCreateWorkingTime, useDeleteWorkingTime, useUpdateWorkingTime } from "@/composables/working-times.ts";

const formatDateTimeLocal = useFormatDateTimeLocal()
const formatDateUTC = useFormatDate()
const createWTAPI = useCreateWorkingTime()
const editWTAPI = useUpdateWorkingTime()
const deleteWTAPI = useDeleteWorkingTime()
const props = defineProps<{
  modelValue?: IWorkingTime;
}>();

const emit = defineEmits(["update:modelValue", "updateAll"]);

const { user } = storeToRefs(useSessionStore());

const vModel = computed({
  get: () => props.modelValue ?? undefined,
  set: (value) => emit("update:modelValue", value),
});

const formValue = ref<{ start: string, end: string, user_id: number }>({
  start: formatDateTimeLocal(new Date()),
  end: formatDateTimeLocal(new Date()),
  user_id: vModel.value?.user_id ?? user.value?.id ?? 0,
});


watch(vModel, () => {
  const startDate = vModel.value ? formatDateUTC(vModel.value.start) : new Date()
  const endDate = vModel.value ? formatDateUTC(vModel.value.end) : new Date()

  formValue.value = {
    start: formatDateTimeLocal(startDate).replace('Z', ''),
    end: formatDateTimeLocal(endDate).replace('Z', ''),
    user_id: vModel.value?.user_id ?? user.value?.id ?? 0,
  }
})

const updateWorkingTime = async () => {
  if (!vModel.value) {
    return
  }

  const response = await editWTAPI(vModel.value.id, {
    start: new Date(formValue.value.start).toISOString(),
    end: new Date(formValue.value.end).toISOString()
  })

  if (!response.ok) {
    return alert('Une erreur est survenue')
  }

  emit('updateAll')
}
const createWorkingTime = async () => {
  if (vModel.value) {
    return
  }

  const response = await createWTAPI(formValue.value.user_id, {
    start: new Date(formValue.value.start).toISOString(),
    end: new Date(formValue.value.end).toISOString(),
    user_id: formValue.value.user_id
  })

  if (!response.ok) {
    return alert('Une erreur est survenue')
  }

  emit('updateAll')
}
const deleteWorkingTime = async () => {
  if (!vModel.value) {
    return
  }

  const response = await deleteWTAPI(vModel.value.id)

  if (!response.ok) {
    return
  }

  emit("updateAll")
}

const onSubmit = () => {
  formValue.value.start = new Date(formValue.value.start).toISOString()
  formValue.value.end = new Date(formValue.value.end).toISOString()

  if (vModel.value) {
    return updateWorkingTime()
  } else
    return createWorkingTime()
};
</script>

<template>
  <section class="working-time-container">
    <AppCard>
      <template v-if="user">
        <form class="working-time-form" @submit.prevent="onSubmit()">
          <div class="space-y-2">
            <div class="input-section">
              <label class="font-semibold">Date de début</label>
              <input
                type="datetime-local"
                class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg"
                v-model="formValue.start"
              />
            </div>
            <div class="input-section">
              <label class="font-semibold">Date de fin</label>
              <input
                type="datetime-local"
                class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg"
                v-model="formValue.end"
              />
            </div>
          </div>

          <div class="delete-btn-container mt-3">
            <AppButton button-style="danger" type="button" v-if="modelValue" class="w-full " @click="deleteWorkingTime">
              <span class="text-white">Supprimer</span>
            </AppButton>
          </div>

          <AppButton type="submit" class="mt-5 w-full" button-style="primary">
            <template v-if="modelValue">
              <span class="text-white">Éditer</span>
            </template>
            <template v-else>
              <span class="text-white">Créer</span>
            </template>
          </AppButton>
        </form>

      </template>
      <template v-else>
        <div class="text-center">
          <span>Veuillez vous identifier</span>
        </div>
      </template>
    </AppCard>
  </section>
</template>

<style scoped>
.delete-btn-container {
  min-height: 40px;
}
</style>