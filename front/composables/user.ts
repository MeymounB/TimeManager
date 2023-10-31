import { useFetchAPI } from "@/composables/fetch";

const runtimeConfig = useRuntimeConfig();
const USERS_ENDPOINT = `${runtimeConfig.public.BACK_URL}/users`;

export function useGetAllUser() {
  return () => {
    return useFetchAPI<IUserShort[]>("GET", USERS_ENDPOINT);
  };
}

export function useGetUser() {
  return (userId: number) => {
    return useFetchAPI<IUser>("GET", `${USERS_ENDPOINT}/${userId}`);
  };
}

export function useCreateUser() {
  return (newUser: IUserDTO) => {
    return useFetchAPI<IUser>("POST", USERS_ENDPOINT, { user: newUser });
  };
}

export function useUpdateUser() {
  return (userId: number, newData: Partial<IUserDTO>) => {
    return useFetchAPI<IUser>("PUT", `${USERS_ENDPOINT}/${userId}`, {
      user: newData,
    });
  };
}

export function useDeleteUser() {
  return (userId: number) => {
    return useFetchAPI<IUser>("DELETE", `${USERS_ENDPOINT}/${userId}`);
  };
}
