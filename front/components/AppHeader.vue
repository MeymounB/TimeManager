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
          <NuxtLink to="/" class="font-bold text-xl">Time Manager PAR-5</NuxtLink>
        </div>
        <div class="ml-auto flex space-x-5 items-center">
          <nav class="text-md font-semibold">
            <ul class="flex decoration-0 space-x-8">
              <li class="hover:underline">
                <NuxtLink to="/">Home</NuxtLink>
              </li>
              <li class="hover:underline">
                <NuxtLink to="/">About</NuxtLink>
              </li>
              <li class="hover:underline">
                <NuxtLink to="/">Contact</NuxtLink>
              </li>
            </ul>
          </nav>
          <div class="border-l border-gray-400 pr-5">
            <div class="ml-5">
              <template v-if="user">
                <button type="button" class="min-h-fit">
                  <span class="rounded-[100px] bg-blue-200 p-[8px] w-[32px] h-[32px] items-center justify-center inline mr-3 font-semibold">
                    {{ user.username[0].toUpperCase() + user.username[1].toUpperCase()}}
                  </span>
                  <span class="">
                    {{ user.email }}
                  </span>
                </button>
<!--                todo: faire le dropdown -->

              </template>
              <template v-else>
                <div class="space-x-3">
                  <AppButton button-style="primary" type="button" @click="navigateTo('/login')">
                    Se connecter
                  </AppButton>
                  <NuxtLink to="/create-account" class="text-sm underline">Créer un compte</NuxtLink>
                </div>
              </template>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped></style>
