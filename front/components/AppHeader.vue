<script setup lang="ts">
const sessionStore = useSessionStore();

const { user } = storeToRefs(sessionStore);
const open = ref(false);
const loading = ref(false);

const logout = async () => {
  if (!user.value) {
    return;
  }
  loading.value = true;

  try {
    await sessionStore.logout();
  } catch (err) {
    loading.value = false;
    return alert(err);
  }
};
</script>

<template>
  <section
    :class="{ '-ml-[100%]': !open }"
    class="transition-all ease-in-out duration-500 lg:transition-none left-0 shadow-lg lg:shadow-none h-screen lg:h-auto fixed lg:ml-0 top-0 lg:sticky w-[90%] md:w-2/5 lg:w-full lg:border-b lg:border-gray-400 bg-white lg:bg-opacity-80 backdrop-blur z-40"
  >
    <div
      class="h-full lg:h-auto"
      :class="{ 'lg:max-w-[90rem] lg:mx-auto': !user }"
    >
      <div
        class="h-full p-5 lg:w-100 lg:px-8 flex lg:flex-row flex-col items-start lg:items-center lg:h-[62px]"
      >
        <div class="mt-5 lg:mt-0">
          <AppButton
            button-style="secondary"
            class="btn-icon block mb-5 lg:hidden"
            type="button"
            @click="open = !open"
          >
            <svg-icon class="w-5 h-5" name="cross" />
          </AppButton>
          <NuxtLink
            to="/"
            class="text-3xl font-extrabold lg:font-bold lg:text-xl"
          >
            Time Manager
          </NuxtLink>
        </div>
        <div
          class="mt-28 h-full lg:ml-auto flex flex-col lg:flex-row lg:space-x-5 justify-around lg:items-center lg:mt-0"
        >
          <template v-if="user">
            <HeaderNavSession />
          </template>
          <template v-else>
            <HeaderNavGuest />
          </template>
          <div class="mt-10 lg:mt-0 lg:border-l lg:border-gray-400 lg:pr-5">
            <div class="lg:ml-5">
              <template v-if="user">
                <div class="hidden lg:block">
                  <AppDropdown button-style="tertiary">
                    <template #dropdown-toggle>
                      <span
                        class="rounded-[100px] bg-blue-200 p-[8px] w-[32px] h-[32px] items-center justify-center flex font-semibold text-sm"
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
                        <ul class="space-y-2 w-full">
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
                            :is-loading="loading"
                            @click="logout"
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
                <div class="w-full lg:hidden">
                  <AppButton
                    button-style="tertiary"
                    type="button"
                    class="flex items-center space-x-2 w-full"
                    @click="navigateTo('/session/profile')"
                  >
                    <span
                      class="rounded-[100px] bg-blue-200 p-[8px] w-[32px] h-[32px] items-center justify-center flex font-semibold text-sm"
                    >
                      {{
                        user.firstname[0].toUpperCase() +
                        user.lastname[0].toUpperCase()
                      }}
                    </span>
                    <span>
                      {{ user.email }}
                    </span>
                  </AppButton>
                  <AppButton
                    button-style="danger"
                    class="flex items-center justify-center mt-3 w-full"
                    type="button"
                    :is-loading="loading"
                    @click="logout"
                  >
                    <svg-icon
                      name="disconnect"
                      class="w-4 h-4 mr-2 inline"
                    ></svg-icon>
                    Déconnexion
                  </AppButton>
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

    <Teleport to="body">
      <AppButton
        button-style="primary"
        type="button"
        class="flex items-center !rounded-xl lg:hidden fixed bottom-10 left-10"
        @click="open = !open"
      >
        <svg-icon class="mr-3 w-5 h-5" name="menu"></svg-icon>
        Menu
      </AppButton>
    </Teleport>
  </section>
</template>

<style scoped></style>
