<script setup lang="ts"></script>

<template>
  <section
    class="auth-layout bg-office-pattern bg-no-repeat bg-cover h-screen w-full"
  >
    <section class="blur-overlay backdrop-blur h-full w-full">
      <div class="bg-white bg-opacity-95 w-full sm:w-2/3 h-full lg:w-2/5 p-5 ml-auto flex flex-col">
        <AppButton
          button-style="secondary"
          type="button"
          class="flex items-center self-start"
          @click="navigateTo('/')"
        >
          <svg-icon name="back-arrow" class="w-3 h-3 mr-2" /> Retour
        </AppButton>
        <div class="flex-grow flex flex-col justify-center items-center px-4">
          <slot />
        </div>
      </div>
    </section>
  </section>
</template>
