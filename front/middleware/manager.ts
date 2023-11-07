import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";

export default defineNuxtRouteMiddleware(() => {
  const session = useSessionStore();
  const { user } = storeToRefs(session);

  if (
    user.value?.role.name !== RolesNames.ADMIN &&
    user.value?.role.name !== RolesNames.GENERAL_MANAGER &&
    user.value?.role.name !== RolesNames.MANAGER
  ) {
    return false;
  }
});
