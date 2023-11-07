import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";
import { isUserManager } from "~/composables/user";

export default defineNuxtRouteMiddleware(() => {
  const session = useSessionStore();
  const { user } = storeToRefs(session);

  if (!user.value) {
    return false;
  }
  return isUserManager(user.value);
});
