import { useFetchAPI } from "@/composables/fetch";
import type { IShortTeam } from "~/utils/teams";
import type { IWorkingTime } from "~/utils/workingTime";

const runtimeConfig = useRuntimeConfig();
const TEAMS_ENDPOINT = `${runtimeConfig.public.BACK_URL}/teams`;

export function useTeams() {
  return () => {
    return useFetchAPI<IShortTeam[]>("GET", TEAMS_ENDPOINT);
  };
}

export function useTeamDetail() {
  return (teamId: number) => {
    return useFetchAPI<ITeam>("GET", `${TEAMS_ENDPOINT}/${teamId}`);
  };
}

export function useTeamWorkingTimes() {
  return (teamId: number) => {
    return useFetchAPI<IWorkingTime[]>(
      "GET",
      `${TEAMS_ENDPOINT}/${teamId}/working_times`,
    );
  };
}
