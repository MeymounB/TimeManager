import { useSessionStore } from "~/stores/sessionStore";

export default defineNuxtRouteMiddleware(() => {
  const session = useSessionStore();

  if (!session.isLoggedIn) {
    return navigateTo("/");
  }
});
