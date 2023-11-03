import { defineStore } from "pinia";
import { StorageSerializers, useLocalStorage } from "@vueuse/core";
import type { IUser, IUserCredentialsDTO, IUserDTO } from "~/utils/user";

export const useSessionStore = defineStore("counter", () => {
  const user = useLocalStorage<IUser | null>("user", null, {
    serializer: StorageSerializers.object,
  });

  const accessToken = ref<null | string>(null);

  async function reloadUser() {
    const response = await useGetMe()();

    if (!response.ok) {
      user.value = null;
      return;
    }

    user.value = response.data;
  }

  async function login(creds: IUserCredentialsDTO) {
    const response = await useLoginAccount()(creds);

    if (!response.ok) {
      throw new Error(`Login failed with status: ${response.status}`);
    }

    accessToken.value = response.data.access_token;
    return await reloadUser();
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
    return await reloadUser();
  }

  function localLogout() {
    if (!user.value) {
      return;
    }

    user.value = null;
    accessToken.value = null;
    navigateTo("/");
  }

  setTimeout(() => {
    reloadUser().catch((err) => console.error(err));
  }, 0);

  return { user, accessToken, localLogout, login, register };
});
