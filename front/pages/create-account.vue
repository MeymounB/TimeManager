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
  <section class="w-full">
    <div class="text-center">
      <h2 class="text-4xl h1 font-bold italic">Créer un compte</h2>
    </div>
    <form class="mt-15 space-y-3 p-5" @submit.prevent="onSubmit">
      <div class="flex gap-5 flex-col md:flex-row">
        <div class="w-full">
          <label for="firstname" class="block text-sm font-medium leading-6">
            Prénom
          </label>
          <div>
            <input
              id="firstname"
              v-model="formValue.firstname"
              name="firstname"
              type="text"
              required
              :class="{ 'ring-red-500': isFieldError('firstname') }"
              class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6"
              @change="vuelidate.firstname.$touch"
            />
          </div>
          <div class="min-h-[25px]">
            <span v-if="isFieldError('firstname')" class="text-sm text-red-500">
              {{ fieldErrorMessage("firstname").value }}
            </span>
          </div>
        </div>

        <div class="w-full">
          <label for="lastname" class="block text-sm font-medium leading-6">
            Nom
          </label>
          <div>
            <input
              id="lastname"
              v-model="formValue.lastname"
              name="lastname"
              type="text"
              required
              :class="{ 'ring-red-500': isFieldError('lastname') }"
              class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6"
              @change="vuelidate.lastname.$touch"
            />
          </div>
          <div class="min-h-[25px]">
            <span v-if="isFieldError('lastname')" class="text-sm text-red-500">
              {{ fieldErrorMessage("lastname").value }}
            </span>
          </div>
        </div>
      </div>
      <div></div>
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
        <label for="password" class="block text-sm font-medium leading-6">
          Mot de passe
        </label>
        <div>
          <input
            id="password"
            v-model="formValue.password"
            name="password"
            type="password"
            autocomplete="new-password"
            required
            :class="{ 'ring-red-500': isFieldError('password') }"
            class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6"
            @change="vuelidate.password.$touch"
          />
        </div>
        <div class="min-h-[25px]">
          <span v-if="isFieldError('password')" class="text-sm text-red-500">
            {{ fieldErrorMessage("password").value }}
          </span>
        </div>
      </div>

      <div>
        <label
          for="password_confirmation"
          class="block text-sm font-medium leading-6"
        >
          Répétez le mot de passe
        </label>
        <div>
          <input
            id="password_confirmation"
            v-model="formValue.password_confirmation"
            name="password_confirmation"
            type="password"
            required
            :class="{ 'ring-red-500': isFieldError('password_confirmation') }"
            class="outline-0 block w-full h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6"
            @change="vuelidate.password_confirmation.$touch"
          />
        </div>
        <div class="min-h-[25px]">
          <span
            v-if="isFieldError('password_confirmation')"
            class="text-sm text-red-500"
          >
            {{ fieldErrorMessage("password_confirmation").value }}
          </span>
        </div>
      </div>

      <div class="errors min-h-[52px] text-red-500">
        <template v-if="formErrorsExist"> API errors here </template>
      </div>

      <AppButton
        type="submit"
        :button-style="'primary'"
        class="flex items-center justify-center w-full"
        :is-disabled="preventSubmit"
      >
        Créer un compte
      </AppButton>
    </form>
  </section>
</template>

<style scoped></style>
