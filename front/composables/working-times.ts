import { useFetchAPI } from "@/composables/fetch";

const runtimeConfig = useRuntimeConfig();
const WT_ENDPOINT = `${runtimeConfig.public.BACK_URL}/workingtimes`;

export function useGetAllWorkingTimes() {
  return () => {
    return useFetchAPI<IWorkingTime[]>("GET", WT_ENDPOINT);
  };
}

export function useGetWorkingTimesForUser() {
  return (userId: number) => {
    return useFetchAPI<IWorkingTime>("GET", `${WT_ENDPOINT}/${userId}`);
  };
}

export function useDeleteWorkingTime() {
  return (wtId: number) => {
    return useFetchAPI("DELETE", `${WT_ENDPOINT}/${wtId}`);
  };
}

export function useCreateWorkingTime() {
  return (userId: number, newWt: IWorkingTimeDTO) => {
    return useFetchAPI("POST", `${WT_ENDPOINT}/${userId}`, {
      working_time: newWt,
    });
  };
}

export function useUpdateWorkingTime() {
  return (wtId: number, newWt: Partial<IWorkingTimeDTO>) => {
    return useFetchAPI("PUT", `${WT_ENDPOINT}/${wtId}`, {
      working_time: newWt,
    });
  };
}
