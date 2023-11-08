<script setup lang="ts">
import { storeToRefs } from "pinia";
import { email, helpers, required } from "@vuelidate/validators";
import useVuelidate from "@vuelidate/core";
import { useSessionStore } from "~/stores/sessionStore";

definePageMeta({
  middleware: ["auth"],
});

const session = useSessionStore();
const { user } = storeToRefs(session);
const updateAccountAPI = useUpdateAccount();

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
  firstnameEdit.value = false;
  lastnameEdit.value = false;
  formValue.email = user.value?.email;
};

const toggleLastnameEdit = () => {
  lastnameEdit.value = !lastnameEdit.value;
  firstnameEdit.value = false;
  emailEdit.value = false;
  formValue.lastname = user.value?.lastname;
};

const toggleFirstnameEdit = () => {
  firstnameEdit.value = !firstnameEdit.value;
  emailEdit.value = false;
  lastnameEdit.value = false;
  formValue.firstname = user.value?.firstname;
};

const onSubmit = async () => {
  if (!user.value) {
    return;
  }
  const toSubmit = {
    ...(formValue.email !== user.value.email ? { email: formValue.email } : {}),
    ...(formValue.firstname !== user.value.firstname
      ? { firstname: formValue.firstname }
      : {}),
    ...(formValue.lastname !== user.value.lastname
      ? { lastname: formValue.lastname }
      : {}),
  };

  const response = await updateAccountAPI(toSubmit);

  if (!response.ok) {
    return alert("Error happened while updating profile");
  }

  await session.reloadUser();
  formValue.email = user.value?.email;
  formValue.firstname = user.value?.firstname;
  formValue.lastname = user.value?.lastname;
  emailEdit.value = false;
  firstnameEdit.value = false;
  lastnameEdit.value = false;
};
</script>

<template>
  <section
    v-if="user"
    class="profile mx-auto bg-white shadow-md rounded-lg max-w-7xl mt-0 md:mt-6"
  >
    <div class="text-center py-6 bg-gray-100 border-b">
      <h1 class="text-3xl font-bold text-gray-800">Votre Profil</h1>
      <p class="text-gray-600">
        Vous pouvez mettre à jour vos informations ci-dessous.
      </p>
    </div>
    <form class="p-4 sm:p-6" @submit.prevent="onSubmit">
      <div class="mb-4">
        <label for="firstname" class="block text-sm font-medium leading-6">
          Prénom
        </label>
        <div
          class="mt-1 flex items-center gap-5"
          :class="{ 'justify-between': !firstnameEdit }"
        >
          <input
            id="firstname"
            v-model="formValue.firstname"
            name="firstname"
            type="text"
            required
            :class="{
              'ring-red-500': isFieldError('email'),
              'px-3 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-gray-500 bg-gray-200 font-normal':
                firstnameEdit,
            }"
            class="outline-0 h-11 bg-transparent w-3/4 rounded-md border-0 py-1.5 sm:text-sm sm:leading-6 font-bold"
            :disabled="!firstnameEdit"
            @change="vuelidate.firstname.$touch"
          />
          <template v-if="firstnameEdit">
            <div
              class="flex justify-evenly sm:flex-row sm:space-x-3 flex-col items-center gap-3 sm:gap-0"
            >
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

      <div class="mb-4">
        <label for="lastname" class="block text-sm font-medium leading-6">
          Nom
        </label>
        <div
          class="mt-1 flex items-center gap-5"
          :class="{ 'justify-between': !lastnameEdit }"
        >
          <input
            id="lastname"
            v-model="formValue.lastname"
            name="lastname"
            type="text"
            required
            :class="{
              'ring-red-500': isFieldError('email'),
              'px-3 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-gray-500 bg-gray-200 font-normal':
                lastnameEdit,
            }"
            class="outline-0 h-11 bg-transparent w-3/4 rounded-md border-0 py-1.5 sm:text-sm sm:leading-6 font-bold"
            :disabled="!lastnameEdit"
            @change="vuelidate.lastname.$touch"
          />
          <template v-if="lastnameEdit">
            <div
              class="flex justify-evenly sm:flex-row sm:space-x-3 flex-col items-center gap-3 sm:gap-0"
            >
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

      <div class="mb-4">
        <label for="email" class="block text-sm font-medium leading-6">
          Email
        </label>
        <div
          class="mt-1 flex items-center gap-5"
          :class="{ 'justify-between': !emailEdit }"
        >
          <input
            id="email"
            v-model="formValue.email"
            name="email"
            type="email"
            required
            :class="{
              'ring-red-500': isFieldError('email'),
              'px-3 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-gray-500 bg-gray-200 font-normal':
                emailEdit,
            }"
            class="outline-0 h-11 bg-transparent w-3/4 rounded-md border-0 py-1.5 sm:text-sm sm:leading-6 font-bold"
            :disabled="!emailEdit"
            @change="vuelidate.email.$touch"
          />
          <template v-if="emailEdit">
            <div
              class="flex justify-evenly sm:flex-row sm:space-x-3 flex-col items-center gap-3 sm:gap-0"
            >
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
      <div class="grid grid-cols-2 divide-x gap-5">
        <div class="p-3">
          <span class="block font-medium">Mes équipes</span>
          <div
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 mt-5"
          >
            <div
              v-for="team in user.teams"
              :key="team.id"
              class="flex items-center gap-3 border border-gray-700 rounded max-w-[200px] px-4 py-2"
            >
              <svg-icon name="team" class="w-5 h-5" />
              <span
                class="font-medium text-center text-sm whitespace-nowrap text-ellipsis overflow-hidden"
                >{{ team.name }}</span
              >
            </div>
          </div>
        </div>

        <div class="p-3">
          <span class="block font-medium">Équipes gérées</span>
          <div
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 mt-5"
          >
            <div
              v-for="team in user.managed_teams"
              :key="team.id"
              class="flex items-center gap-3 border border-gray-700 rounded max-w-[200px] px-4 py-2"
            >
              <svg-icon name="team" class="w-5 h-5" />
              <span
                class="font-medium text-center text-sm whitespace-nowrap text-ellipsis overflow-hidden"
                >{{ team.name }}</span
              >
            </div>
          </div>
        </div>
      </div>
    </form>
  </section>
</template>

<style scoped></style>
