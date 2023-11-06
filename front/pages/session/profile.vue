<script setup lang="ts">
import { storeToRefs } from "pinia";
import { email, helpers, required } from "@vuelidate/validators";
import useVuelidate from "@vuelidate/core";
import { useSessionStore } from "~/stores/sessionStore";

const session = useSessionStore();
const { user } = storeToRefs(session);

const formValue = reactive({
  firstname: user.value?.firstname,
  lastname: user.value?.lastname,
  email: user.value?.email,
});

const rules = computed(() => {
  return {
    firstname: {
      required: helpers.withMessage(
        "le prénom ne peut pas être vide",
        required,
      ),
    },
    lastname: {
      required: helpers.withMessage("Le nom ne peut pas être vide", required),
    },
    email: {
      required: helpers.withMessage("Le champ ne peut pas être vide", required),
      email: helpers.withMessage("Ce n'est pas une adresse mail valide", email),
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

const emailEdit = ref(false);
const lastnameEdit = ref(false);
const firstnameEdit = ref(false);

const toggleEmailEdit = () => {
  emailEdit.value = !emailEdit.value;
  formValue.email = user.value?.email;
};

const toggleLastnameEdit = () => {
  lastnameEdit.value = !lastnameEdit.value;
  formValue.lastname = user.value?.lastname;
};

const toggleFirstnameEdit = () => {
  firstnameEdit.value = !firstnameEdit.value;
  formValue.firstname = user.value?.firstname;
};

const onSubmit = async () => {};
</script>

<template>
  <section v-if="user" class="profile max-w-7xl mx-auto bg-gray-400">
    <form class="p-5" @submit="onSubmit">
      <div>
        <label for="firstname" class="block text-sm font-medium leading-6">
          Prénom
        </label>
        <div class="flex justify-between gap-5">
          <input
            id="firstname"
            v-model="formValue.firstname"
            name="firstname"
            type="text"
            required
            :class="{
              'ring-red-500': isFieldError('firstname'),
              'pointer-events-none bg-transparent ring-0 shadow-none p-0':
                !firstnameEdit,
            }"
            class="outline-0 h-11 w-3/4 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-gray-500 sm:text-sm sm:leading-6"
            @change="vuelidate.firstname.$touch"
          />
          <template v-if="firstnameEdit">
            <div class="space-x-3">
              <AppButton
                button-style="danger"
                type="button"
                class="btn-icon"
                @click="toggleFirstnameEdit"
              >
                <svg-icon name="cross" class="w-5 h-5" />
              </AppButton>
              <AppButton button-style="primary" type="submit" class="btn-icon">
                <svg-icon name="valid" class="w-5 h-5" />
              </AppButton>
            </div>
          </template>
          <template v-else>
            <AppButton
              button-style="tertiary"
              type="button"
              class="btn-icon"
              @click="toggleFirstnameEdit"
            >
              <svg-icon name="edit" class="w-5 h-5" />
            </AppButton>
          </template>
        </div>

        <div class="min-h-[25px]">
          <span v-if="isFieldError('firstname')" class="text-sm text-red-500">
            {{ fieldErrorMessage("firstname").value }}
          </span>
        </div>
      </div>

      <div>
        <label for="lastname" class="block text-sm font-medium leading-6">
          Nom
        </label>
        <div class="flex justify-between gap-5">
          <input
            id="lastname"
            v-model="formValue.lastname"
            name="lastname"
            type="text"
            required
            :class="{ 'ring-red-500': isFieldError('lastname') }"
            class="outline-0 block w-3/4 h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6"
            @change="vuelidate.lastname.$touch"
          />
          <template v-if="lastnameEdit">
            <div class="space-x-3">
              <AppButton
                button-style="danger"
                type="button"
                class="btn-icon"
                @click="toggleLastnameEdit"
              >
                <svg-icon name="cross" class="w-5 h-5" />
              </AppButton>
              <AppButton button-style="primary" type="submit" class="btn-icon">
                <svg-icon name="valid" class="w-5 h-5" />
              </AppButton>
            </div>
          </template>
          <template v-else>
            <AppButton
              button-style="tertiary"
              type="button"
              class="btn-icon"
              @click="toggleLastnameEdit"
            >
              <svg-icon name="edit" class="w-5 h-5" />
            </AppButton>
          </template>
        </div>
        <div class="min-h-[25px]">
          <span v-if="isFieldError('lastname')" class="text-sm text-red-500">
            {{ fieldErrorMessage("lastname").value }}
          </span>
        </div>
      </div>

      <div>
        <label for="email" class="block text-sm font-medium leading-6">
          Email
        </label>
        <div class="flex justify-between gap-5">
          <input
            id="email"
            v-model="formValue.email"
            name="email"
            type="email"
            required
            :class="{ 'ring-red-500': isFieldError('email') }"
            class="outline-0 block w-3/4 h-11 rounded-md border-0 py-1.5 px-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-gray-500 sm:text-sm sm:leading-6"
            @change="vuelidate.email.$touch"
          />
          <template v-if="emailEdit">
            <div class="space-x-3">
              <AppButton
                button-style="danger"
                type="button"
                class="btn-icon"
                @click="toggleEmailEdit"
              >
                <svg-icon name="cross" class="w-5 h-5" />
              </AppButton>
              <AppButton button-style="primary" type="submit" class="btn-icon">
                <svg-icon name="valid" class="w-5 h-5" />
              </AppButton>
            </div>
          </template>
          <template v-else>
            <AppButton
              button-style="tertiary"
              type="button"
              class="btn-icon"
              @click="toggleEmailEdit"
            >
              <svg-icon name="edit" class="w-5 h-5" />
            </AppButton>
          </template>
        </div>
        <div class="min-h-[25px]">
          <span v-if="isFieldError('email')" class="text-sm text-red-500">
            {{ fieldErrorMessage("email").value }}
          </span>
        </div>
      </div>
    </form>
  </section>
</template>

<style scoped></style>