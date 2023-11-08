export enum RolesNames {
  ADMIN = "Admin",
  GENERAL_MANAGER = "General Manager",
  MANAGER = "Manager",
  EMPLOYEE = "Employee",
}

export enum Rights {
  CREATE = "create",
  READ = "read",
  UPDATE = "update",
  DELETE = "delete",
  CLOCK = "clock",
}

export interface IPermission {
  role?: Rights[];
  team?: Rights[];
  account?: Rights[];
  user?: Rights[];
  clock?: Rights[];
}

export interface IRole {
  id: number;
  name: string;
  permissions: Permissions;
}
