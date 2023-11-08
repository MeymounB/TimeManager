import type { IRole } from "~/utils/roles";

const runtimeConfig = useRuntimeConfig();
const ROLE_ENDPOINT = `${runtimeConfig.public.BACK_URL}/roles`;

export function useGetAllRoles() {
  return () => {
    return useFetchAPI<IRole[]>("GET", ROLE_ENDPOINT);
  };
}
