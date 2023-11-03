# Database

## Common fields

Every table has the following fields

| Field       | Type          | Example             |
| ----------- | ------------- | ------------------- |
| id          | bigint        | 1                   |
| inserted_at | utc timestamp | 2023-10-31 10:52:19 |
| updated_at  | utc timestamp | 2023-10-31 10:52:19 |

## User

Represents an application user, which can be either an employee, a manager, a general maanger or an admin. (see [Role](#role) table)

| Field              | Type                                               | Example                  |
| ------------------ | -------------------------------------------------- | ------------------------ |
| firstname          | str                                                | haleigh.schumm           |
| lastname           | str                                                | schumm                   |
| email              | str                                                | haleigh.schumm@adell.biz |
| password_hash      | str                                                | //                       |
| custom_permissions | [map](#permissions)                                | {}                       |
| role               | [Role](#role) (Belongs to)                         | //                       |
| clock              | [Clock](#clock) (Has one)                          | //                       |
| working_times      | Array of [Working Times](#working-time) (Has many) | //                       |

## Team

Represents an employee team handled my one or multiple managers. A manager can mange multiple teams.
A user can be in multiple teams.

| Field     | Type                                  | Example |
| --------- | ------------------------------------- | ------- |
| Name      | str                                   | TeamA   |
| Managers  | Array of [User](#user) (Many to Many) | //      |
| Employees | Array of [User](#user) (Many to Many) | //      |

## Clock

Represents an employee clock.

| Field  | Type                       | Example             |
| ------ | -------------------------- | ------------------- |
| user   | [User](#user) (Belongs to) | //                  |
| time   | utc timestamp              | 2023-10-31 10:52:19 |
| status | boolean                    | true                |

The status field defines whether the clock is running or not:

- When true, the time is when the associated user clocked in to start its working time
- When false, the time is when the associated user clocked out to finish its working time (creating one entry in [Working Time](#working-time))

## Working Time

Represent a working time for a given employee. A working time is created when a user clocks out.

| Field | Type                       | Example             |
| ----- | -------------------------- | ------------------- |
| user  | [User](#user) (Belongs to) | //                  |
| start | utc timestamp              | 2023-10-31 10:52:19 |
| end   | utc timestamp              | 2023-10-31 10:52:19 |

## Role

Represent an application role.

| Field       | Type                | Example |
| ----------- | ------------------- | ------- |
| name        | str                 | Admin   |
| permissions | [map](#permissions) | {}      |

### Permissions

Here is the list of the existing permissions:

#### Scope Account

Authentified user account related permissions. "user" will refeer to the authentified user entry in the database.

| Permission | Description                                                                |
| ---------- | -------------------------------------------------------------------------- |
| Read       | Read user informations                                                     |
| Update     | Edit user informations (name, password...)                                 |
| Delete     | Delete the user account                                                    |
| Clock      | Clock in/out the user. This can result in creation of working time entries |

#### Scope User

User related permissions. Further restrictions may be implemented in each endpoints to restrict access to some specific users.

| Permission | Description                                                                |
| ---------- | -------------------------------------------------------------------------- |
| Create     | Create a new user                                                          |
| Read       | Read user informations                                                     |
| Update     | Edit user informations (name, password...)                                 |
| Delete     | Delete the user account                                                    |
| Clock      | Clock in/out the user. This can result in creation of working time entries |
| Role       | Edit the user role                                                         |

#### Scope Team

Teams related permissions. Further restrictions may be implemented in each endpoints to restrict access to some specific teams.

| Permission | Description                                                                             |
| ---------- | --------------------------------------------------------------------------------------- |
| Create     | Create a new team                                                                       |
| Read       | Read team informations                                                                  |
| Update     | Edit team informations (name, members...)                                               |
| Delete     | Delete a team                                                                           |
| Clock      | Clock in/out all users in the team. This can result in creation of working time entries |
| Role       | Edit the user role                                                                      |

#### Scope Clock

Clock related permissions. This apply to any clock instead of a user/team clock as it was in user/team scopes.

| Permission | Description              |
| ---------- | ------------------------ |
| Read       | Read clocks informations |
| Delete     | Delete a clock           |

#### Scope Working Time

Working Time related permissions.

| Permission | Description                      |
| ---------- | -------------------------------- |
| Create     | Create a new working time        |
| Read       | Read working times informations  |
| Update     | Update working time informations |
| Delete     | Delete a working time entry      |

#### Scope Role

Role related permissions.

| Permission | Description         |
| ---------- | ------------------- |
| Read       | Read existing roles |

### Default Roles

#### Admin

No table needed, the admin has all existing permissions.

#### Employee

Employee is the default role of all users.

They can:

- Edit their account information
- Delete their account
- Report their departure and arrival times
- View their informations

| Scope   | Permissions                 |
| ------- | --------------------------- |
| Account | Read, Update, Delete, Clock |
| Role    | Read                        |

#### Manager

They have the same permissions as the employee and the followings:

- Manage their team
- View the averages of the daily and weekly hours of their team
- View employee informations

| Scope | Permissions                         |
| ----- | ----------------------------------- |
| User  | Read, Clock                         |
| Team  | Create, Read, Update, Delete, Clock |

#### General Manager

They have the same permissions as the employee and the followings:

- Promote a user from the rank of employee to manager
- Delete accounts of any user

| Scope | Permissions  |
| ----- | ------------ |
| User  | Delete, Role |

#### Admin

They have all existing permissions.
