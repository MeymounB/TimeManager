<script setup lang="ts">
definePageMeta({
  middleware: ["auth", "manager"],
});

const getTeamsAPI = useTeams();
const teams = ref<IShortTeam[]>([]);

onMounted(async () => {
  const response = await getTeamsAPI();

  if (!response.ok) {
    return alert("Error happened while fetching");
  }

  teams.value = response.data;
});
</script>

<template></template>

<style scoped></style>
