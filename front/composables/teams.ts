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

export function useUpdateAddTeamMember() {
  return (teamId: number, employeeId: number) => {
    return useFetchAPI<IWorkingTime[]>(
      "PUT",
      `${TEAMS_ENDPOINT}/${teamId}/add_employee/${employeeId}`,
    );
  };
}

export function useUpdateRemoveTeamMember() {
  return (teamId: number, employeeId: number) => {
    return useFetchAPI<IWorkingTime[]>(
      "PUT",
      `${TEAMS_ENDPOINT}/${teamId}/remove_employee/${employeeId}`,
    );
  };
}

export function useDeleteTeam() {
  return (teamId: number) => {
    return useFetchAPI<IWorkingTime[]>("DELETE", `${TEAMS_ENDPOINT}/${teamId}`);
  };
}
