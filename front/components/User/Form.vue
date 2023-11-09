<script lang="ts" setup>
import { email, helpers, required } from "@vuelidate/validators";
import useVuelidate from "@vuelidate/core";
import type { IUser } from "~/utils/user";

const props = defineProps<{
  trueUser: IUser;
  modelValue: IUser;
}>();

const emit = defineEmits(["update:modelValue", "submit"]);

const vModel = computed({
  get: () => props.modelValue,
  set: (value) => emit("update:modelValue", value),
});

const emailEdit = ref(false);
const lastnameEdit = ref(false);
const firstnameEdit = ref(false);

const rules = computed(() => {
  return {
    firstname: {
      required: helpers.withMessage(
        "Le prénom ne peut pas être vide",
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

const vuelidate = useVuelidate(rules, vModel);

const isFieldError = (vuelidateField: string) => {
  return vuelidate.value[vuelidateField as keyof typeof vuelidate.value].$error;
};

const fieldErrorMessage = (vuelidateField: string) => {
  return computed(() => {
    return vuelidate.value[vuelidateField as keyof typeof vuelidate.value]
      ?.$errors[0]?.$message;
  });
};

const toggleEmailEdit = () => {
  emailEdit.value = !emailEdit.value;
  firstnameEdit.value = false;
  lastnameEdit.value = false;
  vModel.value.email = props.trueUser.email;
};

const toggleLastnameEdit = () => {
  lastnameEdit.value = !lastnameEdit.value;
  firstnameEdit.value = false;
  emailEdit.value = false;
  vModel.value.lastname = props.trueUser.lastname;
};

const toggleFirstnameEdit = () => {
  firstnameEdit.value = !firstnameEdit.value;
  emailEdit.value = false;
  lastnameEdit.value = false;
  vModel.value.firstname = props.trueUser.firstname;
};

const onSubmit = () => {
  emailEdit.value = false;
  firstnameEdit.value = false;
  lastnameEdit.value = false;
  emit("submit");
};
</script>

<template>
  <form @submit.prevent="onSubmit">
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
          v-model="vModel.firstname"
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
          v-model="vModel.lastname"
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
          v-model="vModel.email"
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
  </form>
</template>
