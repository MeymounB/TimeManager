<script setup lang="ts">
const menuItems = [
  { name: "cross-box", link: "#rejected", title: "Retours Rejetés" },
  {
    name: "question-mark-circle",
    link: "#company-issues",
    title: "Problèmes d'Entreprise",
  },
  {
    name: "adjustments-horizontal",
    link: "#configurable-actions",
    title: "Actions Configurables",
  },
  { name: "shield-check", link: "#useful", title: "Pourquoi c'est Utile" },
  {
    name: "briefcase",
    link: "#dev-tickets",
    title: "Tickets de Développement",
  },
];
</script>

<template>
  <div class="flex">
    <AppSideBar :menu-items="menuItems">
      <template #icon-cross-box>
        <svg-icon name="cross-box" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-question-mark-circle>
        <svg-icon name="question-mark-circle" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-adjustments-horizontal>
        <svg-icon name="adjustments-horizontal" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-shield-check>
        <svg-icon name="shield-check" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-briefcase>
        <svg-icon name="briefcase" class="h-6 w-6 lg:hidden" />
      </template>
    </AppSideBar>
    <section class="user-feedback-section w-full lg:w-4/5 bg-gray-50 py-12">
      <div class="max-w-4xl mx-auto px-4">
        <h1 class="text-3xl font-bold text-center mb-10">
          Retours des Utilisateurs
        </h1>

        <article id="rejected" class="mb-12">
          <h2 class="text-2xl font-semibold mb-4">Retours Rejetés</h2>
          <p>
            Certaines suggestions ne peuvent pas être implémentées pour diverses
            raisons, y compris la sécurité et la pertinence pour le projet.
          </p>
          <ul class="list-disc pl-5 space-y-2 text-gray-600">
            <UsersFeedbackRejected />
          </ul>
        </article>

        <article id="company-issues" class="mb-12">
          <h2 class="text-2xl font-semibold mb-4">Problèmes d'Entreprise</h2>
          <p>
            Des défis internes à l'entreprise qui sont hors de notre contrôle et
            ne peuvent être résolus directement par l'application.
          </p>
          <ul class="list-disc pl-5 space-y-2 text-gray-600">
            <UsersFeedbackCompanyIssues />
          </ul>
        </article>

        <article id="configurable-actions" class="mb-12">
          <h2 class="text-2xl font-semibold mb-4">
            Actions/Comportements Configurables
          </h2>
          <p>
            Des paramètres personnalisables pour répondre aux besoins
            spécifiques de l'entreprise et de ses employés.
          </p>
          <ul class="list-disc pl-5 space-y-2 text-gray-600">
            <UsersFeedbackConfigurable />
          </ul>
        </article>

        <article id="useful" class="mb-12">
          <h2 class="text-2xl font-semibold mb-4">Pourquoi c'est Utile</h2>
          <p>
            L'application offre plusieurs avantages, y compris l'amélioration de
            la productivité et la précision de l'enregistrement du temps.
          </p>
          <ul class="list-disc pl-5 space-y-2 text-gray-600">
            <UsersFeedbackAdvantages />
          </ul>
        </article>

        <article id="dev-tickets">
          <h2 class="text-2xl font-semibold mb-4">
            Tickets de Développement d'Application
          </h2>
          <p>
            Des fonctionnalités en développement pour améliorer l'expérience
            utilisateur et la gestion du temps de travail.
          </p>
          <ul class="list-disc pl-5 space-y-2 text-gray-600">
            <UsersFeedbackDevTickets />
          </ul>
        </article>
      </div>
    </section>
  </div>
</template>

<style scoped>
.user-feedback-section h1 {
  color: #111827;
}

.user-feedback-section h2 {
  color: #374151;
}

.user-feedback-section p {
  color: #6b7280;
}
</style>
