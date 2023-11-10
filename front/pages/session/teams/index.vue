<script setup lang="ts">
import { storeToRefs } from "pinia";
import type { IShortTeam, ITeam } from "~/utils/teams";
import { useSessionStore } from "~/stores/sessionStore";
import type { IChartData, IChartLabel } from "~/utils/chart";
import type { IUser, IUserShort } from "~/utils/user";

const session = useSessionStore();
const { user } = storeToRefs(session);
const getTeamsAPI = useTeams();
const teams = ref<IShortTeam[]>([]);
const getTeamDetail = useTeamDetail();
const getTeamWorkingTimes = useTeamWorkingTimes();
const teamsDetails = ref<Map<number, ITeam>>(new Map([]));
const teamsChartData = ref<Map<number, IChartData>>(new Map([]));
const formatChartData = useFormatChartDataWorkingTime();

const getAllRoles = useGetAllRoles();
const roles = ref<IRole[]>([]);

const fetchTeamDetail = async (teamId: number) => {
  const response = await getTeamDetail(teamId);

  if (!response.ok) {
    return alert("Error happened while fetching");
  }

  return response.data;
};

const fetchTeamWorkingTimes = async (teamId: number) => {
  const response = await getTeamWorkingTimes(teamId);

  if (!response.ok) {
    return alert("Error happened while fetching");
  }

  return response.data;
};

const fetchAllRoles = async () => {
  const response = await getAllRoles();

  if (!response.ok) {
    return alert("Error happened while fetching");
  }

  roles.value = response.data;
};

const fetchTeams = async () => {
  const response = await getTeamsAPI();

  if (!response.ok) {
    return alert("Error happened while fetching teams");
  }

  teams.value = response.data;

  for (const team of teams.value) {
    const teamDetail: ITeam = await fetchTeamDetail(team.id);
    teamsDetails.value.set(team.id, teamDetail);

    if (userManageTeam(user.value as IUser, teamDetail.id)) {
      const teamWorkingTimes = await fetchTeamWorkingTimes(team.id);

      if (!teamWorkingTimes) {
        continue;
      }

      const users: IUserShort[] = Array.prototype.concat(
        teamDetail.employees,
        teamDetail.managers,
      );
      const usersChartLabels: IChartLabel[] = users.map(
        (u: IUserShort): IChartLabel => ({
          id: u.id,
          name: u.firstname,
        }),
      );
      teamsChartData.value.set(
        team.id,
        formatChartData(usersChartLabels, teamWorkingTimes),
      );
    }
  }
};

const userManager = computed(() => {
  return isUserManager(user.value as IUser);
});

const getRoleName = (roleId: number) => {
  const role = roles.value.find((role) => role.id === roleId);

  return role?.name ?? "N/A";
};

onMounted(async () => {
  await fetchTeams();
  await fetchAllRoles();
});
</script>

<template>
  <section v-if="teams" class="teams max-w-7xl mx-auto mt-5">
    <div
      id="accordion-flush-teams"
      class="space-y-6"
      data-accordion="collapse"
      data-active-classes="bg-gray-100"
    >
      <AppAccordion
        v-for="team in teams"
        :id="`team-${team.id}`"
        :key="team.id"
      >
        <template #header>
          <div class="w-full flex items-center justify-between pr-10">
            <span>
              <svg-icon name="team" class="w-5 h-5 mr-5 inline" />
              {{ team.name }}
            </span>
          </div>
        </template>
        <template #content>
          <div v-if="teamsChartData.get(team.id)" class="h-72">
            <VueChartBar :chart-data="teamsChartData.get(team.id)" />
          </div>
          <template
            v-else-if="
              userManageTeam(user as IUser, team.id) &&
              !teamsChartData.get(team.id)
            "
          >
            <div class="w-full flex justify-center">
              <AppSpinner />
            </div>
          </template>
          <table
            v-if="teamsDetails.get(team.id)"
            class="w-full text-left text-sm font-light overflow-hidden table-fixed lg:table-auto mx-auto"
          >
            <thead class="border-b font-medium">
              <tr>
                <th
                  scope="col"
                  class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap"
                >
                  Prénom
                </th>
                <th
                  scope="col"
                  class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap"
                >
                  Nom
                </th>
                <th
                  scope="col"
                  class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap"
                >
                  Email
                </th>
                <th
                  scope="col"
                  class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap"
                >
                  Role
                </th>
                <th
                  v-if="userManager"
                  scope="col"
                  class="py-4 overflow-x-hidden text-ellipsis whitespace-nowrap text-center"
                >
                  Actions
                </th>
              </tr>
            </thead>
            <tbody>
              <template v-if="teamsDetails.get(team.id).managers.length > 0">
                <tr
                  v-for="tableUser in teamsDetails.get(team.id).managers"
                  :key="tableUser.id"
                  class="border-b transition duration-300 ease-in-out h-10"
                >
                  <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
                    {{ tableUser.firstname }}
                  </td>
                  <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
                    {{ tableUser.lastname }}
                  </td>
                  <td class="whitespace-nowrap overflow-hidden text-ellipsis">
                    {{ tableUser.email }}
                  </td>
                  <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
                    {{ getRoleName(tableUser.role_id) }}
                  </td>
                  <td v-if="userManager" class="text-center">
                    <AppButton
                      button-style="tertiary"
                      type="button"
                      class="btn-icon"
                      @click="navigateTo(`/session/users/${tableUser.id}`)"
                    >
                      <svg-icon name="eye" class="w-4 h-4" />
                    </AppButton>
                  </td>
                </tr>
              </template>
              <template v-if="teamsDetails.get(team.id).employees.length > 0">
                <tr
                  v-for="tableUser in teamsDetails.get(team.id).employees"
                  :key="tableUser.id"
                  class="border-b transition duration-300 ease-in-out h-10"
                >
                  <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
                    {{ tableUser.firstname }}
                  </td>
                  <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
                    {{ tableUser.lastname }}
                  </td>
                  <td class="whitespace-nowrap overflow-hidden text-ellipsis">
                    {{ tableUser.email }}
                  </td>
                  <td class="overflow-x-hidden text-ellipsis whitespace-nowrap">
                    {{ getRoleName(tableUser.role_id) }}
                  </td>
                  <td v-if="userManager" class="text-center">
                    <AppButton
                      button-style="tertiary"
                      type="button"
                      class="btn-icon"
                      @click="navigateTo(`/session/users/${tableUser.id}`)"
                    >
                      <svg-icon name="eye" class="w-4 h-4" />
                    </AppButton>
                  </td>
                </tr>
              </template>
              <template
                v-if="
                  teamsDetails.get(team.id).employees.length <= 0 &&
                  teamsDetails.get(team.id).managers.length <= 0
                "
              >
                <tr>
                  <td colspan="99" class="text-center px-6 py-4">
                    Aucune donnée
                  </td>
                </tr>
              </template>
            </tbody>
          </table>
          <template v-else>
            <div class="w-full flex justify-center">
              <AppSpinner />
            </div>
          </template>
        </template>
      </AppAccordion>
    </div>
  </section>
</template>

<style scoped></style>
