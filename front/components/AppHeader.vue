<script setup lang="ts">
const sessionStore = useSessionStore();

const { user } = storeToRefs(sessionStore);
</script>

<template>
  <section
    class="top-0 sticky w-full border-b border-gray-400 bg-white bg-opacity-80 backdrop-blur z-40"
  >
    <div class="max-w-[90rem] mx-auto">
      <div class="w-100 py-3 px-8 flex items-center">
        <div>
          <span class="font-bold text-xl">Time Manager PAR-5</span>
        </div>
        <div class="ml-auto flex space-x-5 items-center">
          <nav class="text-md font-semibold">
            <ul class="flex decoration-0 space-x-8">
              <li>
                <NuxtLink to="/">Home</NuxtLink>
              </li>
              <li>
                <NuxtLink to="/">About</NuxtLink>
              </li>
              <li>
                <NuxtLink to="/">Contact</NuxtLink>
              </li>
            </ul>
          </nav>
          <div class="border-l border-gray-400 pr-5">
            <div class="ml-5">
              <template v-if="user">
                <span>
                  {{ user.email }}
                </span>
              </template>
              <template v-else>
                <AppButton button-style="primary" type="button">
                  Se connecter
                </AppButton>
              </template>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped></style>
