import { useFetchAPI } from "@/composables/fetch";
import type { IUser, IUserShort } from "~/utils/user";
import type { IShortTeam } from "~/utils/teams";

const runtimeConfig = useRuntimeConfig();
const USERS_ENDPOINT = `${runtimeConfig.public.BACK_URL}/users`;

export function useGetAllUser() {
  return () => {
    return useFetchAPI<IUserShort[]>("GET", USERS_ENDPOINT);
  };
}

export function useGetUser() {
  return (userId: number) => {
    return useFetchAPI<IUser>("GET", `${USERS_ENDPOINT}/${userId}`);
  };
}

export function useCreateUser() {
  return (newUser: IUserDTO) => {
    return useFetchAPI<IUser>("POST", USERS_ENDPOINT, { user: newUser });
  };
}

export function useUpdateUser() {
  return (userId: number, newData: Partial<IUserDTO>) => {
    return useFetchAPI<IUser>("PUT", `${USERS_ENDPOINT}/${userId}`, {
      user: newData,
    });
  };
}

export function useDeleteUser() {
  return (userId: number) => {
    return useFetchAPI<IUser>("DELETE", `${USERS_ENDPOINT}/${userId}`);
  };
}

export function isUserManager(user: IUser) {
  return !(
    user.role.name !== RolesNames.ADMIN &&
    user.role.name !== RolesNames.GENERAL_MANAGER &&
    user.role.name !== RolesNames.MANAGER
  );
}

export function isUserGeneralManager(user: IUser) {
  return !(
    user.role.name !== RolesNames.ADMIN &&
    user.role.name !== RolesNames.GENERAL_MANAGER
  );
}

export function isUserAdmin(user: IUser) {
  return !(user.role.name !== RolesNames.ADMIN);
}

export function userManageTeam(user: IUser, teamId: number) {
  return (
    user.managed_teams.find((mT) => mT.id === teamId) !== undefined ||
    isUserGeneralManager(user)
  );
}

export function userInSameTeam(user: IUser, target: IUserShort) {
  return user.teams
    .map((t) => t.id)
    .some((r) => target.teams.map((t: ITeam) => t.id).includes(r));
}

export function userManageable(user: IUser, target: IUserShort) {
  return (
    user.managed_teams
      .map((t) => t.id)
      .some((r) => target.teams.map((t: IShortTeam) => t.id).includes(r)) ||
    (isUserGeneralManager(user) && target.role_id >= user.role_id)
  );
}
