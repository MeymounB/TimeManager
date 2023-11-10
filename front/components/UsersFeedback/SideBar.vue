<template>
  <aside class="sidebar lg:w-64 bg-white">
    <nav
      class="flex lg:flex-col items-center justify-center sticky top-1/2 lg:top-[62px] -translate-y-1/2 lg:translate-y-0 overflow-x-auto lg:overflow-x-hidden"
    >
      <ul class="flex flex-col p-4">
        <li class="border-b border-gray-200">
          <NuxtLink
            to="#rejected"
            class="flex items-center hover:text-blue-600 py-2"
          >
            <svg-icon name="cross-box" class="h-6 w-6 lg:hidden" />
            <span class="hidden lg:block">Retours Rejetés</span>
          </NuxtLink>
        </li>
        <li class="border-b border-gray-200">
          <NuxtLink
            to="#company-issues"
            class="flex items-center hover:text-blue-600 py-2"
          >
            <svg-icon name="question-mark-circle" class="h-6 w-6 lg:hidden" />
            <span class="hidden lg:block">Problèmes d'Entreprise</span>
          </NuxtLink>
        </li>
        <li class="border-b border-gray-200">
          <NuxtLink
            to="#configurable-actions"
            class="flex items-center hover:text-blue-600 py-2"
          >
            <svg-icon name="adjustments-horizontal" class="h-6 w-6 lg:hidden" />
            <span class="hidden lg:block">Actions Configurables</span>
          </NuxtLink>
        </li>
        <li class="border-b border-gray-200">
          <NuxtLink
            to="#useful"
            class="flex items-center hover:text-blue-600 py-2"
          >
            <svg-icon name="shield-check" class="h-6 w-6 lg:hidden" />
            <span class="hidden lg:block">Pourquoi c'est Utile</span>
          </NuxtLink>
        </li>
        <li>
          <NuxtLink
            to="#dev-tickets"
            class="flex items-center hover:text-blue-600 py-2"
          >
            <svg-icon name="briefcase" class="h-6 w-6 lg:hidden" />
            <span class="hidden lg:block">Tickets de Développement</span>
          </NuxtLink>
        </li>
      </ul>
    </nav>
  </aside>
</template>
