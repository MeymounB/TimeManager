<script setup lang="ts"></script>

<template>
  <div class="hero-section bg-blue-100">
    <div class="text-center p-4 sm:p-8 md:p-16">
      <h1 class="text-2xl sm:text-3xl md:text-5xl font-bold text-gray-800">
        Bienvenue sur Time Manager
      </h1>
      <p class="mt-3 text-base sm:text-lg text-gray-600">
        La solution intuitive pour une gestion du temps efficace au sein de la mairie de Gotham.
      </p>
      <div class="mt-6 flex flex-col sm:flex-row justify-center items-center">
        <button
          class="text-white font-bold py-2 px-4 rounded transition duration-300 mb-2 sm:mb-0 sm:mr-2 btn-primary"
          @click="navigateTo('/create-account')"
        >
          Inscrivez-vous maintenant
        </button>
        <button
          class="bg-transparent font-semibold py-2 px-4 border rounded transition duration-300 mt-2 sm:mt-0 btn-secondary"
          @click="navigateTo('/login')"
        >
          Connectez-vous
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
