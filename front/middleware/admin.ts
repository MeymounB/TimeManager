import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";

export default defineNuxtRouteMiddleware(() => {
  const session = useSessionStore();
  const { user } = storeToRefs(session);

  if (user.value?.role.name !== RolesNames.ADMIN) {
    return false;
  }
});
