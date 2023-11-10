<script setup lang="ts">
const menuItems = [
  { name: "cross-box", link: "#rejected", title: "Retours Rejetés" },
  {
    name: "question-mark-circle",
    link: "#company-issues",
    title: "",
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
    <section></section>
  </div>
</template>
