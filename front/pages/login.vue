<script setup lang="ts">
import { helpers, required } from "@vuelidate/validators";
import useVuelidate from "@vuelidate/core";
import { useSessionStore } from "~/stores/sessionStore";

const sessionStore = useSessionStore();

definePageMeta({
  layout: "auth",
  middleware: ["guest"],
});

const formValue = reactive<IUserCredentialsDTO>({
  email: "",
  password: "",
});

const rules = computed(() => {
  return {
    email: {
      required: helpers.withMessage("L'adresse mail est requise", required),
    },
  };
});

const vuelidate = useVuelidate(rules, formValue);

const isFieldError = (vuelidateField: string) => {
  return vuelidate.value[vuelidateField as keyof typeof vuelidate.value].$error;
};

const fieldErrorMessage = (vuelidateField: string) => {
  return computed(() => {
    return vuelidate.value[vuelidateField as keyof typeof vuelidate.value]
      ?.$errors[0]?.$message;
  });
};

const preventSubmit = computed(() => {
  for (const key in formValue) {
    if (!formValue[key as keyof typeof formValue]) {
      return true;
    }
  }
});

const formError = ref<string | null>(null);

const onSubmit = async () => {
  formError.value = null;
  try {
    await sessionStore.login(formValue);
  } catch (err) {
    formError.value = "Identifiant ou mot de passe incorrects";
  }
};
</script>

<template>
  <section class="w-full">
    <div class="text-center">
      <h2 class="text-4xl h1 font-bold italic">TimeManager</h2>
      <span class="text-sm italic">Connectez vous à votre espace</span>
    </div>
    <form class="mt-15 p-5" @submit.prevent="onSubmit">
      <div>
        <label for="email" class="block text-sm font-medium leading-6">
          Email
        </label>
        <div>
          <input
            id="email"
            v-model="formValue.email"
            name="email"
            type="email"
            autocomplete="email"
            required
            :class="{ 'ring-red-500': isFieldError('email') }"
            class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6"
            @change="vuelidate.email.$touch"
          />
        </div>
        <div class="min-h-[25px]">
          <span v-if="isFieldError('email')" class="text-sm text-red-500">
            {{ fieldErrorMessage("email").value }}
          </span>
        </div>
      </div>

      <div>
        <div class="flex items-center justify-between">
          <label for="password" class="block text-sm font-medium leading-6">
            Mot de passe
          </label>
        </div>
        <div>
          <input
            id="password"
            v-model="formValue.password"
            name="password"
            type="password"
            autocomplete="current-password"
            required
            class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6"
          />
        </div>
      </div>

      <div class="errors min-h-[32px] mt-10 text-red-500">
        <template v-if="formError">
          <span class="text-red-500">{{ formError }}</span>
        </template>
      </div>

      <AppButton
        type="submit"
        :button-style="'primary'"
        class="flex items-center justify-center w-full md:w-1/3 ml-auto"
        :is-disabled="preventSubmit"
      >
        <svg-icon name="login" class="w-4 h-4 mr-3" /> Connexion
      </AppButton>
    </form>
  </section>
</template>

<style scoped></style>
