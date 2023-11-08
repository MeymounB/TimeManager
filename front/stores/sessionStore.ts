import { defineStore } from "pinia";
import { StorageSerializers, useLocalStorage } from "@vueuse/core";
import type { IUser, IUserCredentialsDTO, IUserDTO } from "~/utils/user";

export const useSessionStore = defineStore("counter", () => {
  const user = useLocalStorage<IUser | null>("user", null, {
    serializer: StorageSerializers.object,
  });

  const accessToken = useLocalStorage<null | string>("accessToken", null, {
    serializer: StorageSerializers.string,
  });

  const refreshToken = useLocalStorage<null | string>("refreshToken", null, {
    serializer: StorageSerializers.string,
  });

  const isLoggedIn = computed(() => user.value != null);

  async function reloadUser() {
    const response = await useGetMe()();

    if (!response.ok) {
      localLogout();
      return;
    }
    user.value = response.data;
  }

  async function refreshSession() {
    if (!refreshToken.value) {
      return localLogout();
    }

    const response = await useRefreshAccount()(refreshToken.value);

    if (!response.ok) {
      await logout();
      return false;
    }

    accessToken.value = response.data.access_token;
    return true;
  }

  async function login(creds: IUserCredentialsDTO) {
    const response = await useLoginAccount()(creds);

    if (!response.ok) {
      throw new Error(`Login failed with status: ${response.status}`);
    }

    accessToken.value = response.data.access_token;
    refreshToken.value = response.data.refresh_token;
    await reloadUser();
    navigateTo("/session/dashboard");
  }

  async function register(newMe: IUserDTO) {
    if (user.value) {
      return;
    }

    const response = await useRegisterAccount()(newMe);

    if (!response.ok) {
      throw new Error(`Failed to create user: ${response.status}`);
    }

    accessToken.value = response.data.access_token;
    refreshToken.value = response.data.refresh_token;
    await reloadUser();
    navigateTo("/session/dashboard");
  }

  async function logout() {
    if (!user.value) {
      return;
    }

    const response = await useLogoutAccount()();

    if (!response.ok) {
      throw new Error(`Failed to logout user: ${response.status}`);
    }

    return localLogout();
  }

  function localLogout() {
    if (!user.value) {
      return;
    }

    user.value = null;
    accessToken.value = null;
    refreshToken.value = null;
    navigateTo("/login");
  }

  setTimeout(() => {
    reloadUser().catch((err) => console.error(err));
  }, 0);

  return {
    user,
    accessToken,
    localLogout,
    login,
    register,
    refreshSession,
    reloadUser,
    logout,
    isLoggedIn,
  };
});
