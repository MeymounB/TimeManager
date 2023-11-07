import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";
import { isUserGeneralManager, isUserManager } from "~/composables/user";

export default defineNuxtRouteMiddleware(() => {
  const session = useSessionStore();
  const { user } = storeToRefs(session);

  if (!user.value) {
    return false;
  }
  return isUserGeneralManager(user.value);
});
