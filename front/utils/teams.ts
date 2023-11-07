import type { IUserShort } from "~/utils/user";

export interface IShortTeam {
  id: number;
  name: string;
}

export interface ITeam extends IShortTeam {
  employees: IUserShort[];
  managers: IUserShort[];
}
