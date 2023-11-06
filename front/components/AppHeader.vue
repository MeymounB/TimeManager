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
          <NuxtLink to="/" class="font-bold text-xl">
            Time Manager PAR-5
          </NuxtLink>
        </div>
        <div class="ml-auto flex space-x-5 items-center">
          <template v-if="user">
            <HeaderNavSession />
          </template>
          <template v-else>
            <HeaderNavGuest />
          </template>
          <div class="border-l border-gray-400 pr-5">
            <div class="ml-5">
              <template v-if="user">
                <div class="relative">
                  <AppDropdown button-style="tertiary">
                    <template #dropdown-toggle>
                      <span
                        class="rounded-[100px] bg-blue-200 p-[8px] w-[32px] h-[32px] items-center justify-center flex font-semibold"
                      >
                        {{
                          user.firstname[0].toUpperCase() +
                          user.lastname[0].toUpperCase()
                        }}
                      </span>
                      <span>
                        {{ user.email }}
                      </span>
                    </template>
                    <template #dropdown-content>
                      <nav>
                        <ul class="space-y-2">
                          <li>
                            <NuxtLink
                              to="/session/profile"
                              class="w-full flex items-center px-4 py-2 rounded hover:bg-gray-200"
                            >
                              <svg-icon
                                name="profile"
                                class="w-5 h-5 inline mr-2"
                              />
                              Profil
                            </NuxtLink>
                          </li>
                          <AppButton
                            button-style="danger"
                            class="w-full flex items-center justify-center"
                            type="button"
                            @click="sessionStore.localLogout()"
                          >
                            <svg-icon
                              name="disconnect"
                              class="w-4 h-4 mr-2 inline"
                            ></svg-icon>
                            Déconnexion
                          </AppButton>
                        </ul>
                      </nav>
                    </template>
                  </AppDropdown>
                </div>
              </template>
              <template v-else>
                <div class="space-x-3">
                  <AppButton
                    button-style="primary"
                    type="button"
                    @click="navigateTo('/login')"
                  >
                    Se connecter
                  </AppButton>
                  <NuxtLink to="/create-account" class="text-sm underline"
                    >Créer un compte</NuxtLink
                  >
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
