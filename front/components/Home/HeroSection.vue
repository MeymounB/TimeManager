<script setup lang="ts"></script>

<template>
  <div class="hero-section bg-blue-100 h-[60vh] flex justify-center items-center shadow-lg transition duration-500 ease-in-out transform hover:shadow-2xl">
    <div class="text-center px-4 py-8 sm:p-8 md:p-16 bg-white bg-opacity-90 rounded-lg shadow-md transition-all duration-300 ease-in-out hover:bg-opacity-100">
      <h1 class="text-3xl sm:text-3xl md:text-5xl font-bold text-gray-800 leading-tight">
        Bienvenue sur Time Manager
      </h1>
      <p class="mt-3 text-base sm:text-lg text-gray-600">
        La solution intuitive pour une gestion du temps efficace au sein de la mairie de Gotham.
      </p>
      <div class="mt-6 flex flex-col sm:flex-row justify-center items-center gap-4 sm:gap-2">
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
