<script setup lang="ts">
const menuItems = [
  {
    name: "hashtag",
    link: "#introduction",
    title: "Introduction",
    icon: "light-bulb" /* "info-circle", "question-mark-circle" */,
  },
  {
    name: "team",
    link: "#users-permissions",
    title: "Catégories d'Utilisateurs et Permissions",
    icon: "team" /* "users", "identification" */,
  },
  {
    name: "flag",
    link: "#tutorial",
    title: "Mise en Place de l'Application",
    icon: "cog-8-tooth" /* "wrench", "co-6-tooth" */,
  },
  {
    name: "chart-bar",
    link: "#features-dashboard",
    title: "Fonctionnalités du Dashboard",
    icon: "chart-pie" /* "chart-bar-square", "presentation-chart-bar" */,
  },
  {
    name: "shield-check",
    link: "#politics",
    title: "Politiques & Feedbacks",
    icon: "shield-exclamation" /* "shield-check", "exclamation-circle" */,
  },
  {
    name: "adjustments-horizontal",
    link: "#configurable",
    title: "Paramètres Configurables",
    icon: "adjustments-vertical" /* "adjustments-vertical", "toggles" */,
  },
  {
    name: "shield-check",
    link: "#time-manager",
    title: "L'Importance de Time Manager",
    icon: "star" /* "trophy", "sparkles" */,
  },
  {
    name: "briefcase",
    link: "#features-app",
    title: "Fonctionnalités de l'Application",
    icon: "puzzle-piece" /* "apps", "collection" */,
  },
  {
    name: "lifebuoy",
    link: "#support",
    title: "Accessibilité et Support",
    icon: "question-mark-circle" /* "phone", "lifebuoy" */,
  },
  {
    name: "calendar",
    link: "#workingtime",
    title: "Gestion des Temps de travail",
    icon: "clock" /* "timer", "watch" */,
  },
];
</script>

<template>
  <div class="flex">
    <AppSideBar :menu-items="menuItems">
      <template #icon-hashtag>
        <svg-icon name="light-bulb" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-team>
        <svg-icon name="team" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-flag>
        <svg-icon name="cog-8-tooth" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-chart-bar>
        <svg-icon name="chart-pie" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-shield-check>
        <svg-icon name="shield-exclamation" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-adjustments-horizontal>
        <svg-icon name="adjustments-vertical" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-shield-check-2>
        <svg-icon name="star" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-briefcase>
        <svg-icon name="puzzle-piece" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-lifebuoy>
        <svg-icon name="question-mark-circle" class="h-6 w-6 lg:hidden" />
      </template>
      <template #icon-calendar>
        <svg-icon name="clock" class="h-6 w-6 lg:hidden" />
      </template>
    </AppSideBar>
    <section class="user-feedback-section flex-grow bg-gray-50 py-12 w-full">
      <div class="max-w-4xl mx-auto px-4 space-y-12">
        <article id="introduction">
          <h2 class="text-2xl font-bold">Introduction</h2>
          <!-- Contenu de l'introduction -->
        </article>
        <article id="users-permissions">
          <h2 class="text-2xl font-bold">
            Catégories d'Utilisateurs et Permissions
          </h2>
          <!-- Contenu des catégories d'utilisateurs et permissions -->
        </article>
        <article id="tutorial">
          <h2 class="text-2xl font-bold">Mise en Place de l'Application</h2>
          <!-- Contenu de la mise en place de l'application -->
        </article>
        <article id="features-dashboard">
          <h2 class="text-2xl font-bold">Fonctionnalités du Dashboard</h2>
          <!-- Contenu des fonctionnalités du dashboard -->
        </article>
        <article id="politics">
          <h2 class="text-2xl font-bold">Politiques & Feedbacks</h2>
          <!-- Contenu des politiques et feedbacks -->
        </article>
        <article id="configurable">
          <h2 class="text-2xl font-bold">Paramètres Configurables</h2>
          <!-- Contenu des paramètres configurables -->
        </article>
        <article id="time-manager">
          <h2 class="text-2xl font-bold">L'Importance de Time Manager</h2>
          <!-- Contenu de l'importance de Time Manager -->
        </article>
        <article id="features-app">
          <h2 class="text-2xl font-bold">Fonctionnalités de l'Application</h2>
          <!-- Contenu des fonctionnalités de l'application -->
        </article>
        <article id="support">
          <h2 class="text-2xl font-bold">Accessibilité et Support</h2>
          <!-- Contenu de l'accessibilité et du support -->
        </article>
        <article id="workingtime">
          <h2 class="text-2xl font-bold">Gestion des Temps de travail</h2>
          <!-- Contenu de la gestion des temps de travail -->
        </article>
      </div>
    </section>
  </div>
</template>
