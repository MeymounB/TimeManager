import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";
import { isUserAdmin } from "~/composables/user";

export default defineNuxtRouteMiddleware(() => {
  const session = useSessionStore();
  const { user } = storeToRefs(session);

  if (!user.value) {
    return false;
  }
  return isUserAdmin(user.value);
});
