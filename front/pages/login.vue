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
  <section class="w-full h-full flex flex-col justify-center items-center p-4">
    <div class="w-full max-w-md mx-auto text-center">
      <h2 class="text-2xl md:text-4xl font-bold italic">TimeManager</h2>
      <span class="text-xs md:text-sm italic"
        >Connectez-vous à votre espace</span
      >
    </div>
    <form class="w-full max-w-md mx-auto mt-4" @submit.prevent="onSubmit">
      <div>
        <label for="email" class="block text-sm font-medium"> Email </label>
        <input
          id="email"
          v-model="formValue.email"
          name="email"
          type="email"
          autocomplete="email"
          required
          :class="{ 'ring-red-500': isFieldError('email') }"
          class="mt-1 block w-full h-10 rounded-md py-2 px-4 text-gray-900 ring-1 ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500"
          @change="vuelidate.email.$touch"
        />
        <div class="min-h-[25px]">
          <span v-if="isFieldError('email')" class="text-xs text-red-500">
            {{ fieldErrorMessage("email").value }}
          </span>
        </div>
      </div>

      <div class="mt-4">
        <label for="password" class="block text-sm font-medium">
          Mot de passe
        </label>
        <input
          id="password"
          v-model="formValue.password"
          name="password"
          type="password"
          autocomplete="current-password"
          required
          class="mt-1 block w-full h-10 rounded-md py-2 px-4 text-gray-900 ring-1 ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500"
        />
      </div>
      <template v-if="formError" class="errors mt-4 text-xs text-red-500">
        {{ formError }}
      </template>
      <AppButton
        type="submit"
        button-style="primary"
        class="mt-6 w-full flex items-center justify-center"
        :is-disabled="preventSubmit"
      >
        <svg-icon name="login" class="w-4 h-4 mr-2" /> Connexion
      </AppButton>
    </form>
  </section>
</template>


<style scoped></style>
