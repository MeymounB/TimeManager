<script setup>
import { reactive } from "vue";

const form = reactive({
  name: "",
  email: "",
  message: "",
});

const sendContactForm = () => {
  // logique pour envoyer le formulaire, API / service messagerie
};
</script>

<template>
  <section class="contact-section bg-gray-100 py-8 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md mx-auto">
      <h1 class="text-2xl font-bold text-center text-gray-900 sm:text-3xl">
        Contactez-Nous
      </h1>
      <p class="text-center text-gray-600 my-4">
        Avez-vous des questions ou des commentaires? Remplissez le formulaire
        ci-dessous et nous vous répondrons dès que possible.
      </p>
      <form
        class="bg-white shadow rounded-lg p-4 sm:p-6 lg:p-8"
        @submit.prevent="sendContactForm"
      >
        <div class="mb-4">
          <label for="name" class="block text-sm font-medium text-gray-700">
            Nom complet
          </label>
          <input
            id="name"
            v-model="form.name"
            type="text"
            required
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50"
          />
        </div>
        <div class="mb-4">
          <label for="email" class="block text-sm font-medium text-gray-700"
            >Email</label
          >
          <input
            id="email"
            v-model="form.email"
            type="email"
            required
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50"
          />
        </div>
        <div class="mb-4">
          <label for="message" class="block text-sm font-medium text-gray-700"
            >Votre message</label
          >
          <textarea
            id="message"
            v-model="form.message"
            rows="4"
            required
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50"
          ></textarea>
        </div>
        <div class="text-right">
          <AppButton
            button-style="primary"
            type="submit"
            class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          >
            Envoyer le message
          </AppButton>
        </div>
      </form>
    </div>
  </section>
</template>

<style scoped></style>
