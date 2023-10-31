import type { IWorkingTime } from "~/utils/workingTime";
import type { IClock } from "~/utils/clock";

export interface IUserShort {
  id: number;
  email: string;
  username: string;
}

export interface IUser extends IUserShort {
  clock: IClock;
  workingTimes: IWorkingTime[];
}

export interface IUserDTO {
  email: string;
  username: string;
}
