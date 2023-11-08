import { useFetchAPI } from "@/composables/fetch";
import type { IShortTeam } from "~/utils/teams";

const runtimeConfig = useRuntimeConfig();
const TEAMS_ENDPOINT = `${runtimeConfig.public.BACK_URL}/teams`;

export function useTeams() {
  return () => {
    return useFetchAPI<IShortTeam[]>("GET", TEAMS_ENDPOINT);
  };
}