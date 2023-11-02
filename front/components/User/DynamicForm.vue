<script setup lang="ts">
import { storeToRefs } from "pinia";
import { useSessionStore } from "@/stores/sessionStore";

const { user } = storeToRefs(useSessionStore());

const formValue = ref<Partial<IUserDTO>>({
  email: user.value?.email ?? "",
  username: user.value?.username ?? "",
});

const isFormValueEmpty = computed(() => {
  return formValue.value.email === "" || formValue.value.username === "";
});

watch(user, () => {
  formValue.value = {
    email: user.value?.email ?? "",
    username: user.value?.username ?? "",
  };
});
const updateUserAPI = useUpdateUser();
const createUserAPI = useCreateUser();

// const getUser = () => ({ user })

const updateUser = async () => {
  if (!user.value) {
    return;
  }
  const response = await updateUserAPI(user.value.id, formValue.value);

  if (!response.ok) {
    return alert("Une erreur est surevenue");
  }
  user.value = response.data;
};

const onSubmit = () => {
  if (!user.value) {
    return;
  }
  return updateUser();
};
</script>

<template>
  <section class="user-form">
    <form @submit.prevent="onSubmit">
      <div class="space-y-2">
        <div class="input-section">
          <label class="font-semibold">Email</label>
          <input
            v-model="formValue.email"
            type="text"
            class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg"
            placeholder="email@box.com"
          />
        </div>
        <div class="input-section">
          <label class="font-semibold">Username</label>
          <input
            v-model="formValue.username"
            type="text"
            class="input-group py-2 px-3 text-black outline-0 border border-black rounded-lg"
            placeholder="fancy123"
          />
        </div>
      </div>

      <AppButton
        type="submit"
        class="mt-5 w-full"
        button-style="primary"
        :is-disabled="isFormValueEmpty"
      >
        <span class="text-white">Editer</span>
      </AppButton>
    </form>
  </section>
</template>
