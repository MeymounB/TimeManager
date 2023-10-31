import { useFetchAPI } from "@/composables/fetch";

const runTimeConfig = useRuntimeConfig();
const CLOCK_ENDPOINT = `${runTimeConfig.public.BACK_URL}/clocks`;

export function useGetAllClock() {
  return () => {
    return useFetchAPI<IClock[]>(`GET`, CLOCK_ENDPOINT);
  };
}

export function useGetClock() {
  return (userId: number) => {
    return useFetchAPI<IClock>("GET", `${CLOCK_ENDPOINT}/${userId}`);
  };
}

export function useClockUser() {
  return (userId: number) => {
    return useFetchAPI<IClock>("POST", `${CLOCK_ENDPOINT}/${userId}`);
  };
}
