<script setup lang="ts">
import {
  helpers,
  required,
  minLength,
  email,
  sameAs,
} from "@vuelidate/validators";
import useVuelidate from "@vuelidate/core";
import type { IUserDTO } from "~/utils/user";
import { useSessionStore } from "~/stores/sessionStore";

definePageMeta({
  layout: "auth",
  middleware: ["guest"],
});

const sessionStore = useSessionStore();

const formValue = reactive<IUserDTO>({
  firstname: "",
  lastname: "",
  email: "",
  password: "",
  password_confirmation: "",
});

const rules = computed(() => {
  return {
    firstname: {
      required: helpers.withMessage("Le prénom est requis", required),
    },
    lastname: {
      required: helpers.withMessage("Le nom est requis", required),
    },
    email: {
      required: helpers.withMessage("L'adresse mail est requise", required),
      email: helpers.withMessage("Ce n'est pas une adresse mail valide", email),
    },
    password: {
      required: helpers.withMessage(
        "Le mot de passe est obligatoire",
        required,
      ),
      minLength: helpers.withMessage(
        "Le mot de passe doit au moins faire 6 caractères",
        minLength(6),
      ),
    },
    password_confirmation: {
      required: helpers.withMessage(
        "Vous devez confirmer votre mot de passe",
        required,
      ),
      sameAs: helpers.withMessage(
        "Les mots de passe ne concordent pas",
        sameAs(formValue.password),
      ),
    },
  };
});

const vuelidate = useVuelidate(rules, formValue);

const formErrors = ref<{ message: string }[]>([]);
const formErrorsExist = computed(() => {
  return formErrors.value.length > 0;
});

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

const onSubmit = async () => {
  formErrors.value.length = 0;
  try {
    await sessionStore.register(formValue);
  } catch (err) {
    formErrors.value.push({
      message: "La creation de l'utilisateur est impossible",
    });
  }
};
</script>

<template>
  <section class="flex flex-col items-center w-full h-full p-4">
    <div class="max-w-md text-center">
      <h2 class="text-2xl md:text-4xl font-bold italic">Créer un compte</h2>
    </div>
    <form class="w-full max-w-md mt-4 space-y-4" @submit.prevent="onSubmit">
      <div class="flex flex-col space-y-4 md:space-y-0 md:space-x-4 md:flex-row">
        <div class="w-full">
          <label for="firstname" class="block text-sm font-medium">
            Prénom
          </label>
          <input
            id="firstname"
            v-model="formValue.firstname"
            name="firstname"
            type="text"
            required
            :class="{ 'ring-red-500': isFieldError('firstname') }"
            class="mt-1 block w-full h-10 rounded-md py-2 px-4 text-gray-900 ring-1 ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500"
            @change="vuelidate.firstname.$touch"
          />
          <span v-if="isFieldError('firstname')" class="text-xs text-red-500">
            {{ fieldErrorMessage("firstname").value }}
          </span>
        </div>

        <div class="w-full">
          <label for="lastname" class="block text-sm font-medium">
            Nom
          </label>
          <input
            id="lastname"
            v-model="formValue.lastname"
            name="lastname"
            type="text"
            required
            :class="{ 'ring-red-500': isFieldError('lastname') }"
            class="mt-1 block w-full h-10 rounded-md py-2 px-4 text-gray-900 ring-1 ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500"
            @change="vuelidate.lastname.$touch"
          />
          <span v-if="isFieldError('lastname')" class="text-xs text-red-500">
            {{ fieldErrorMessage("lastname").value }}
          </span>
        </div>
      </div>
      <div>
        <label for="email" class="block text-sm font-medium">
          Email
        </label>
        <input
          id="email"
          v-model="formValue.email"
          name="email"
          type="email"
          required
          :class="{ 'ring-red-500': isFieldError('email') }"
          class="mt-1 block w-full h-10 rounded-md py-2 px-4 text-gray-900 ring-1 ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500"
          @change="vuelidate.email.$touch"
        />
        <span v-if="isFieldError('email')" class="text-xs text-red-500">
          {{ fieldErrorMessage("email").value }}
        </span>
      </div>

      <div>
        <label for="password" class="block text-sm font-medium">
          Mot de passe
        </label>
        <input
          id="password"
          v-model="formValue.password"
          name="password"
          type="password"
          autocomplete="new-password"
          required
          :class="{ 'ring-red-500': isFieldError('password') }"
          class="mt-1 block w-full h-10 rounded-md py-2 px-4 text-gray-900 ring-1 ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500"
          @change="vuelidate.password.$touch"
        />
        <span v-if="isFieldError('password')" class="text-xs text-red-500">
          {{ fieldErrorMessage("password").value }}
        </span>
      </div>

      <div>
        <label for="password_confirmation" class="block text-sm font-medium">
          Répétez le mot de passe
        </label>
        <input
          id="password_confirmation"
          v-model="formValue.password_confirmation"
          name="password_confirmation"
          type="password"
          required
          :class="{ 'ring-red-500': isFieldError('password_confirmation') }"
          class="mt-1 block w-full h-10 rounded-md py-2 px-4 text-gray-900 ring-1 ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500"
          @change="vuelidate.password_confirmation.$touch"
        />
        <span v-if="isFieldError('password_confirmation')" class="text-xs text-red-500">
          {{ fieldErrorMessage("password_confirmation").value }}
        </span>
      </div>

      <template v-if="formErrorsExist" class="mt-4 text-xs text-red-500">
       API errors here
      </template>

      <AppButton
        type="submit"
        button-style="primary"
        class="w-full flex items-center justify-center mt-6"
        :is-disabled="preventSubmit"
      >
        Créer un compte
      </AppButton>
    </form>
  </section>
</template>


<style scoped></style>
