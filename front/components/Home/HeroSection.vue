<script setup lang="ts">
import { useRouter } from 'vue-router';

const router = useRouter();

function navigateToSignup() {
  router.push('/create-account');
}

function navigateToLogin() {
  router.push('/login');
}
</script>

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
          class="bg-blue-600 text-white font-bold py-2 px-4 rounded hover:bg-blue-700 transition duration-300 mb-2 sm:mb-0 sm:mr-2"
          @click="navigateToSignup()"
        >
          Inscrivez-vous maintenant
        </button>
        <button
          class="bg-transparent text-blue-600 font-semibold py-2 px-4 border border-blue-600 rounded hover:border-blue-800 transition duration-300 mt-2 sm:mt-0"
          @click="navigateToLogin()"
        >
          Connectez-vous
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.hero-section {
  background-image: url('background-image.jpg');
  background-size: cover;
  background-position: center;
}

@media (max-width: 640px) {
  .hero-section {
    background-image: none;
  }
}
</style>
