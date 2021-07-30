## Create a Database

Create a database using the following ERD for the MVP of Time Tracker

![](https://p-vvf5mjm.b1.n0.cdn.getcloudapp.com/items/6quxL9AE/Image%202020-12-01%20at%207.57.45%20PM.png?source=viewer&v=9d21601cf2984d2b5d66d5b4330b6c63)

Some clarifications:

- The `rate` of the user is their cost per hour (in US\$)
- The `total_budget` is the amount of money allocated to one user on one project between the start and end date of the project.
- The `closed` attribute of a Project define if a project is open (`false`) or closed (`true`).
- The Daily-Log register how many hour each member has invest on a project in one day.

1. Create a new database called `timetracker`

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
postgres=# \l

              Name               |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
---------------------------------+----------+----------+-------------+-------------+-----------------------
 ...
 timetracker                     | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 ...
(xx rows)
```

2. Create the table `user` following the ERD.
   - id should be auto incremented.
   - No field should be null.
   - `rate` should be grater than or equal to 0.

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
timetracker=# \d user
                                   Table "public.user"
 Column |         Type          | Collation | Nullable |             Default
--------+-----------------------+-----------+----------+----------------------------------
 id     | integer               |           | not null | nextval('user_id_seq'::regclass)
 name   | character varying(50) |           | not null |
 email  | character varying(25) |           | not null |
 role   | character varying(50) |           | not null |
 rate   | integer               |           | not null |
Indexes:
    "user_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "user_rate_check" CHECK (rate >= 0)
```

3. Create the table `project` following the ERD
   - id should be auto incremented.
   - No field should be null
   - By default the `closed` attribute should be `false`

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
timetracker=# \d project
                                     Table "public.project"
   Column   |         Type          | Collation | Nullable |               Default
------------+-----------------------+-----------+----------+-------------------------------------
 id         | integer               |           | not null | nextval('project_id_seq'::regclass)
 name       | character varying(25) |           | not null |
 category   | character varying(25) |           | not null |
 start_date | date                  |           | not null |
 end_date   | date                  |           | not null |
 closed     | boolean               |           | not null | false
Indexes:
    "project_pkey" PRIMARY KEY, btree (id)
```

## Create relationships

4. Create the `user-project` table.
   - id should be auto incremented.
   - `total_budget` should be grater than or equal to 0.

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
timetracker=# \d user-project
                                Table "public.user-project"
    Column    |  Type   | Collation | Nullable |                  Default
--------------+---------+-----------+----------+--------------------------------------------
 id           | integer |           | not null | nextval('"user-project_id_seq"'::regclass)
 user_id      | integer |           | not null |
 project_id   | integer |           | not null |
 total_budget | integer |           | not null |
Indexes:
    "user-project_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "user-project_total_budget_check" CHECK (total_budget >= 0)
Foreign-key constraints:
    "user-project_project_id_fkey" FOREIGN KEY (project_id) REFERENCES project(id)
    "user-project_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "user"(id)
```

5. Create the `daily-log` table,
   - id should be auto incremented.
   - All fields are required.
   - `hours` should be grater than or equal to 0.

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
timetracker=# \d daily-log
                                  Table "public.daily-log"
     Column      |  Type   | Collation | Nullable |                 Default
-----------------+---------+-----------+----------+-----------------------------------------
 id              | integer |           | not null | nextval('"daily-log_id_seq"'::regclass)
 user_project_id | integer |           | not null |
 date            | date    |           | not null |
 hours           | integer |           | not null |
Indexes:
    "daily-log_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "daily-log_hours_check" CHECK (hours >= 0)
Foreign-key constraints:
    "daily-log_user_project_id_fkey" FOREIGN KEY (user_project_id) REFERENCES "user-project"(id)
```

## Alter a database

After some revision, some changes should be done to our database.

6. Changes on the `user` table
   - The`email` field should be unique.
   - The name and role fields length are not enough. Change it to a maximum of 50 characters.

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
timetracker=# \d user
                                   Table "public.user"
 Column |         Type          | Collation | Nullable |             Default
--------+-----------------------+-----------+----------+----------------------------------
 id     | integer               |           | not null | nextval('user_id_seq'::regclass)
 name   | character varying(50) |           | not null |
 email  | character varying(25) |           | not null |
 role   | character varying(50) |           | not null |
 rate   | integer               |           | not null |
Indexes:
    "user_pkey" PRIMARY KEY, btree (id)
    "User_email_key" UNIQUE CONSTRAINT, btree (email)
Check constraints:
    "user_rate_check" CHECK (rate >= 0)
Referenced by:
    TABLE ""user-project"" CONSTRAINT "user-project_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "user"(id)
```

7. Changes on the `project` table,
   - `end_date` should be greater than `start_date`

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
timetracker=# \d project
                                     Table "public.project"
   Column   |         Type          | Collation | Nullable |               Default
------------+-----------------------+-----------+----------+-------------------------------------
 id         | integer               |           | not null | nextval('project_id_seq'::regclass)
 name       | character varying(25) |           | not null |
 category   | character varying(25) |           | not null |
 start_date | date                  |           | not null |
 end_date   | date                  |           | not null |
 closed     | boolean               |           | not null | false
Indexes:
    "project_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "End_after_start_check" CHECK (end_date > start_date)
Referenced by:
    TABLE ""user-project"" CONSTRAINT "user-project_project_id_fkey" FOREIGN KEY (project_id) REFERENCES project(id)
```

8. Changes on the `user-project` table to have unique combination of user_id and project_id

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
timetracker=# \d user-project
                                Table "public.user-project"
    Column    |  Type   | Collation | Nullable |                  Default
--------------+---------+-----------+----------+--------------------------------------------
 id           | integer |           | not null | nextval('"user-project_id_seq"'::regclass)
 user_id      | integer |           | not null |
 project_id   | integer |           | not null |
 total_budget | integer |           | not null |
Indexes:
    "user-project_pkey" PRIMARY KEY, btree (id)
    "User-Project_unique_FKs" UNIQUE CONSTRAINT, btree (user_id, project_id)
Check constraints:
    "user-project_total_budget_check" CHECK (total_budget >= 0)
Foreign-key constraints:
    "user-project_project_id_fkey" FOREIGN KEY (project_id) REFERENCES project(id)
    "user-project_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "user"(id)
Referenced by:
    TABLE ""daily-log"" CONSTRAINT "daily-log_user_project_id_fkey" FOREIGN KEY (user_project_id) REFERENCES "user-project"(id)
```

9. Changes on the `daily-log` table to have unique combination of user_project_id and date

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

Expected result:

```bash
timetracker=# \d daily-log
                                  Table "public.daily-log"
     Column      |  Type   | Collation | Nullable |                 Default
-----------------+---------+-----------+----------+-----------------------------------------
 id              | integer |           | not null | nextval('"daily-log_id_seq"'::regclass)
 user_project_id | integer |           | not null |
 date            | date    |           | not null |
 hours           | integer |           | not null |
Indexes:
    "daily-log_pkey" PRIMARY KEY, btree (id)
    "user_project_id-date unique" UNIQUE CONSTRAINT, btree (user_project_id, date)
Check constraints:
    "daily-log_hours_check" CHECK (hours >= 0)
Foreign-key constraints:
    "daily-log_user_project_id_fkey" FOREIGN KEY (user_project_id) REFERENCES "user-project"(id)
```

## Insert values (to check the result just make a SELECT query 🙂)

While the app gets ready, the team has been tracking their hours manually. Use [this google document](https://docs.google.com/spreadsheets/d/1KrQXWFzv4Nddss2p3xVC9V_ME5vH3ghN0n7JNhLoVQ8/edit?usp=sharing) to populate your newly created tables.

10. Insert the `user` data.

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

11. Insert the `project` data.

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

12. Insert the `user-Project` data.

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```

13. Insert the `daily-log` data.

```SQL
<INSERT YOUR SQL STATEMENTS HERE>
```
