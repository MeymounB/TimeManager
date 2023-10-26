<script setup lang="ts">
import { IWorkingTime, IWorkingTimeDTO } from "@/types/workingTime.ts";
import AppButton from "@/components/AppButton.vue";
import { computed, reactive } from "vue";
import { useSessionStore } from "@/stores/sessionStore.ts";
import { storeToRefs } from "pinia";
import AppCard from "@/components/AppCard.vue";

const props = defineProps<{
  modelValue?: IWorkingTime
}>()

const emit = defineEmits(['update:modelValue'])

const { user }  = storeToRefs(useSessionStore())

const vModel = computed({
  get: () => props.modelValue ?? undefined,
  set: (value) => emit('update:modelValue', value)
})

const formValue = reactive<IWorkingTimeDTO>({
  start: vModel.value?.start ?? new Date(),
  end: vModel.value?.end ?? new Date(),
  user_id: vModel.value?.user_id ?? user.value?.id ?? 0,
})

const onSubmit = () => {

}

</script>

<template>
  <section class="working-time-container">
    <AppCard title="WorkingTime">
      <template v-if="user">
        <form class="working-time-form" @submit.prevent="onSubmit()">
          <div class="space-y-2">
            <div class="input-section">
              <label class="font-semibold">Date de début</label>
              <input
                type="date"
                class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg"
                v-model="formValue.start"
              />
            </div>
            <div class="input-section">
              <label class="font-semibold">Date de fin</label>
              <input
                type="date"
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
</style>