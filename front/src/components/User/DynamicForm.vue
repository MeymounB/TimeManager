<script setup lang="ts">
import AppButton from "@/components/AppButton.vue";
import { storeToRefs } from "pinia";
import { useSessionStore } from "@/stores/sessionStore.ts";
import { IUserDTO } from "@/types/user.ts";
import { ref, watch } from "vue";
import { useCreateUser, useUpdateUser } from "@/composables/user.ts";

const { user } = storeToRefs(useSessionStore());

const formValue = ref<IUserDTO>({
  email: user.value?.email ?? '',
  username: user.value?.username  ?? '',
})

watch(user, () => {
  formValue.value = {
    email: user.value?.email ?? '',
    username: user.value?.username  ?? '',
  }
})
const updateUserAPI = useUpdateUser()
const createUserAPI = useCreateUser()

const editUser = async () => {
  if (!user.value) {
    return
  }
  const response = await updateUserAPI(user.value.id, formValue.value)

  if (!response.ok) {
    return alert('Une erreur est surevenue')
  }
  user.value = response.data
}

const createUser = async () => {
  const response = await  createUserAPI(formValue.value)

  if (!response.ok) {
    return alert("L'utilisateur n'a pu être créé")
  }

  user.value = response.data
}

const onSubmit = async () => {
  if (!user.value) {
    return createUser()
  } else {
    return editUser()
  }
};
</script>

<template>
  <section class="user-form">
    <form @submit.prevent="onSubmit">
      <div class="space-y-2">
        <div class="input-section">
          <label class="font-semibold">Email</label>
          <input
            type="text"
            class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg"
            placeholder="email@box.com"
            v-model="formValue.email"
          />
        </div>
        <div class="input-section">
          <label class="font-semibold">Username</label>
          <input
            type="text"
            class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg"
            placeholder="fancy123"
            v-model="formValue.username"
          />
        </div>
      </div>

      <AppButton type="submit" class="mt-5 w-full" button-style="primary">
        <template v-if="user">
          <span class="text-white">Éditer</span>
        </template>
        <template v-else>
          <span class="text-white">Créer</span>
        </template>
      </AppButton>
    </form>
  </section>
</template>
