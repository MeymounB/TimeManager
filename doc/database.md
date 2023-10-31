# Database

## Common fields

Every table has the following fields

| Field       | Type          | Example             |
| ----------- | ------------- | ------------------- |
| id          | bigint        | 1                   |
| inserted_at | utc timestamp | 2023-10-31 10:52:19 |
| updated_at  | utc timestamp | 2023-10-31 10:52:19 |

## User

Represents an application user, which can be either an employee, a manager or an admin. The roles will be handled in another table.

| Field         | Type                                               | Example                       |
| ------------- | -------------------------------------------------- | ----------------------------- |
| username      | str                                                | dr.haleigh.schumm.i           |
| email         | str                                                | dr.haleigh.schumm.i@adell.biz |
| clock         | [Clock](#clock) (Has one)                          | //                            |
| working_times | Array of [Working Times](#working-time) (Has many) | //                            |

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
