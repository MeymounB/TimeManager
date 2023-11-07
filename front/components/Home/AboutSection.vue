<template>
  <div class="about-section my-12 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
    <div class="mb-10">
      <h2 class="text-center text-3xl font-extrabold text-gray-900">
        À propos de Time Manager
      </h2>
      <p class="mt-4 text-center text-lg text-gray-600">
        Dans les couloirs de l'hôtel de ville de Gotham, une révolte gronde. Time Manager est né de la nécessité de répondre aux conditions de travail difficiles, aux longues heures et aux besoins de répit des employés municipaux.
      </p>
    </div>

    <div class="features-list grid grid-cols-1 gap-6 md:grid-cols-3">
      <div class="feature-item bg-white p-6 shadow-sm rounded-lg flex flex-col items-center text-center">
      <!-- Image -->
        <svg-icon class="h-12 w-12 mb-3" src="/" alt="Gestion du Temps" name="cross" />
        <h3 class="mb-2 font-semibold text-gray-900">Gestion du Temps</h3>
        <p class="text-sm text-gray-600">
          Suivi précis des heures de travail pour optimiser la productivité.
        </p>
      </div>

      <div class="feature-item bg-white p-6 shadow-sm rounded-lg flex flex-col items-center text-center">
      <!-- Image -->
        <svg-icon class="h-12 w-12 mb-3"  alt="Gestion d'Équipe" name="cross" />
        <h3 class="mb-2 font-semibold text-gray-900">Gestion d'Équipe</h3>
        <p class="text-sm text-gray-600">
          Organisation des équipes avec des outils de communication intégrés.
        </p>
      </div>

      <div class="feature-item bg-white p-6 shadow-sm rounded-lg flex flex-col items-center text-center">
      <!-- Image -->
        <svg-icon class="h-12 w-12 mb-3" alt="Rapports Détaillés" name="cross" />
        <h3 class="mb-2 font-semibold text-gray-900">Rapports Détaillés</h3>
        <p class="text-sm text-gray-600">
          Des rapports d'activités complets pour un suivi en temps réel.
        </p>
      </div>
    </div>

    <div class="testimonials mt-16 px-4 sm:px-0">
      <h3 class="text-center text-2xl font-extrabold text-gray-900">
        Ce que disent nos utilisateurs
      </h3>
      <div class="mt-8 space-y-8 mx-auto max-w-xl">
        <blockquote class="bg-white p-6 shadow-sm rounded-lg text-center">
          <p class="text-lg text-gray-600">
            "Grâce à Time Manager, nous pouvons enfin gérer nos horaires avec flexibilité et transparence."
          </p>
          <footer class="mt-4 text-base font-semibold">
            - Syndicat CGT-U de Gotham
          </footer>
        </blockquote>

        <blockquote class="bg-white p-6 shadow-sm rounded-lg text-center">
          <p class="text-lg text-gray-600">
            "Time Manager a transformé notre façon de travailler. Les longues heures sont derrière nous!"
          </p>
          <footer class="mt-4 text-base font-semibold">
            - Un employé de la mairie de Gotham
          </footer>
        </blockquote>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
@media (max-width: 640px) {
  .testimonials blockquote {
    /* Un carousel // un slider */
  }
}
</style>
