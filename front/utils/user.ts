import type { IWorkingTime } from "~/utils/workingTime";
import type { IClock } from "~/utils/clock";
import type { IRole } from "~/utils/roles";
import type { IShortTeam } from "~/utils/teams";

export interface IUserShort {
  id: number;
  email: string;
  firstname: string;
  lastname: string;
  role_id: number;
  clock: IClock;
  teams: IShortTeam[];
  custom_permissions: Permissions;
}

export interface IUser extends IUserShort {
  role: IRole;
  working_times: IWorkingTime[];
  managed_teams: IShortTeam[];
}

export interface IUserDTO {
  firstname: string;
  lastname: string;
  password: string;
  password_confirmation: string;
  email: string;
}

export interface IUserCredentialsDTO {
  email: string;
  password: string;
}

export interface IUserEditDTO {
  lastname?: string;
  firstname?: string;
  email?: string;
}
