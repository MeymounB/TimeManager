<script setup lang="ts">
import { IWorkingTime } from "@/types/workingTime.ts";
import AppButton from "@/components/AppButton.vue";
import { computed, ref, watch } from "vue";
import { useSessionStore } from "@/stores/sessionStore.ts";
import { storeToRefs } from "pinia";
import AppCard from "@/components/AppCard.vue";
import { useFormatDate, useFormatDateTimeLocal } from "@/composables/dateFormat.ts";
import { useDeleteWorkingTime } from "@/composables/working-times.ts";

const formatDateTimeLocal = useFormatDateTimeLocal()
const formatDateUTC = useFormatDate()
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
    start: formatDateTimeLocal(startDate),
    end: formatDateTimeLocal(endDate),
    user_id: vModel.value?.user_id ?? user.value?.id ?? 0,
  }
})

const editWT = async () => {}
const createWT = async () => {}
const deleteWT = async () => {
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
  if (vModel.value) {
    return createWT()
  } else
    return editWT()
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

          <AppButton type="submit" class="mt-5 w-full" button-style="primary">
            <template v-if="modelValue">
              <span class="text-white">Éditer</span>
            </template>
            <template v-else>
              <span class="text-white">Créer</span>
            </template>
          </AppButton>
        </form>
        <AppButton button-style="danger" type="button" v-if="modelValue" class="mt-5 w-full">
          <span class="text-white">Supprimer</span>
        </AppButton>
      </template>
      <template v-else>
        <div class="text-center">
          <span>Veuillez vous identifier</span>
        </div>
      </template>
    </AppCard>
  </section>
</template>

<style scoped></style>