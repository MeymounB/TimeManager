import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";
import { useFetchAPI } from "~/composables/fetch";

const runtimeConfig = useRuntimeConfig();
const ACCOUNT_ENDPOINT = `${runtimeConfig.public.BACK_URL}/account`;

export function useGetMe() {
  const { accessToken } = storeToRefs(useSessionStore());

  return () => {
    return useFetchAPI<IUser>("GET", ACCOUNT_ENDPOINT, {}, accessToken.value);
  };
}

export function useRegisterAccount() {
  return (newUser: IUserDTO) => {
    return useFetchAPI<ITokens>("POST", `${ACCOUNT_ENDPOINT}/register`, {
      newUser,
    });
  };
}

export function useLoginAccount() {
  return (newUser: IUserCredentialsDTO) => {
    return useFetchAPI<ITokens>("POST", `${ACCOUNT_ENDPOINT}/login`, {
      newUser,
    });
  };
}

export function useDeleteAccount() {
  const { accessToken } = storeToRefs(useSessionStore());

  return () => {
    return useFetchAPI<IUser>(
      "DELETE",
      ACCOUNT_ENDPOINT,
      {},
      accessToken.value,
    );
  };
}

export function useUpdateAccount() {
  const { accessToken } = storeToRefs(useSessionStore());

  return (newData: Partial<IUserDTO>) => {
    return useFetchAPI<IUser>(
      "PUT",
      ACCOUNT_ENDPOINT,
      newData,
      accessToken.value,
    );
  };
}
