import { useFetchAPI } from "~/composables/fetch";
import type { ITokens } from "~/utils/tokens";
import type { IWorkingTime } from "~/utils/workingTime";

const runtimeConfig = useRuntimeConfig();
const ACCOUNT_ENDPOINT = `${runtimeConfig.public.BACK_URL}/account`;

export function useGetMe() {
  return () => {
    return useFetchAPI<IUser>("GET", ACCOUNT_ENDPOINT);
  };
}

export function useRegisterAccount() {
  return (newUser: IUserDTO) => {
    return useFetchAPI<ITokens>(
      "POST",
      `${ACCOUNT_ENDPOINT}/register`,
      newUser,
      true,
    );
  };
}

export function useLoginAccount() {
  return async (creds: IUserCredentialsDTO) => {
    return await useFetchAPI<ITokens>(
      "POST",
      `${ACCOUNT_ENDPOINT}/login`,
      creds,
      true,
    );
  };
}

export function useDeleteAccount() {
  return () => {
    return useFetchAPI<IUser>("DELETE", ACCOUNT_ENDPOINT);
  };
}

export function useUpdateAccount() {
  return (newData: Partial<IUserDTO>) => {
    return useFetchAPI<IUser>("PUT", ACCOUNT_ENDPOINT, { user: newData });
  };
}

export function useLogoutAccount() {
  return () => {
    return useFetchAPI<IUser>("POST", `${ACCOUNT_ENDPOINT}/logout`);
  };
}

export function useRefreshAccount() {
  // eslint-disable-next-line camelcase
  return (refresh_token: string) => {
    return useFetchAPI<ITokens>("POST", `${ACCOUNT_ENDPOINT}/refresh`, {
      // eslint-disable-next-line camelcase
      refresh_token,
    });
  };
}

export function useAccountWorkingTimes() {
  return () => {
    return useFetchAPI<IWorkingTime[]>(
      "GET",
      `${ACCOUNT_ENDPOINT}/working_times`,
    );
  };
}
