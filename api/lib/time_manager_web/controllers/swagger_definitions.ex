defmodule TimeManagerWeb.SwaggerDefinitions do
  use PhoenixSwagger

  def global_definitions do
    %{
      ErrorReason: swagger_schema do
        title("ErrorReason")
        description("An error")

        properties do
          _type(:string, "Errror type")
          message(:string, "Error message")
          stack(Schema.array(:string), "Error stack trace. Only in debug mode")
        end

        example(%{
          _type: "Elixir.Ecto.NoResultsError",
          message: "expected at least one result but got none"
        })
      end,
      NotFoundResponse: swagger_schema do
        title("NotFoundResponse")
        description("A resource was requested but the server was unavailable to find it")

        properties do
          reason(:ErrorReason, "Error reason")
        end
      end,
      UnprocessableEntityResponse: swagger_schema do
        title("UnprocessableEntityResponse")
        description("An action was requested to the server but the input was invalid")

        properties do
          errors(%Schema{type: :object}, "Error reasons. An entry for each invalid parameters with an array of reasons.")
        end

        example(%{
          errors: %{
            email: [
              "has already been taken"
            ]
          }
        })
      end
    }
  end

  def user_definitions do
    %{
        User: swagger_schema do
          title("User")
          description("A user of the app.")

          properties do
            id(:integer, "User ID")
            firstname(:string, "User firstname")
            lastname(:string, "User lastname")
            email(:string, "Email address", format: :email)
            role_id(:integer, "User role ID")
            custom_permissions(Schema.ref(:Permissions), "User additional permissions")
          end

          example(%{
            id: 1,
            firstname: "Joe",
            lastname: "Doe",
            email: "joe@gmail.com",
            role_id: 1,
            custom_permissions: %{},
          })
        end,
        UserDetailed: swagger_schema do
          title("UserDetailed")
          description("A user of the app with its associations")

          properties do
            id(:integer, "User ID")
            firstname(:string, "User firstname")
            lastname(:string, "User lastname")
            email(:string, "Email address", format: :email)
            role(Schema.ref(:Role), "User role")
            custom_permissions(Schema.ref(:Permissions), "User additional permissions")
            teams(Schema.array(:Team), "User teams (as an employee in the team)")
            managed_teams(Schema.array(:Team), "User managed teams. Only for user with role manager and higher.")
            clock(Schema.ref(:Clock), "User clock", "x-nullable": true)
            working_times(Schema.array(:WorkingTime), "User working times")
          end

          example(%{
            id: 1,
            firstname: "Joe",
            lastname: "Doe",
            email: "joe@gmail.com",
            role: %{
              id: 3,
              name: "Manager",
              permissions: %{}
            },
            custom_permissions: %{},
            teams: [],
            managed_teams: [],
            clock: %{
              id: 1,
              user_id: 1,
              time: "2017-02-04 11:24:45",
              status: false
            },
            working_times: []
          })
        end,
        UserRequest:
        swagger_schema do
          title("UserRequest")
          description("POST body for creating a user")
          property(:user, :User, "The user details")
        end,
        UserResponse: swagger_schema do
          title("UserResponse")
          description("Response schema for single user")
          property(:data, :UserDetailed, "The user details")
        end,
        UsersResponse:
        swagger_schema do
          title("UsersReponse")
          description("Response schema for multiple users")
          property(:data, Schema.array(:User), "The users details")
        end
    }
  end

  def clocks_definitions do
    %{
        Clock: swagger_schema do
          title("Clock")
          description("A user clock")

          properties do
            id(:integer, "Clock ID")
            user_id(:integer, "Associated user ID")
            time(:string, "Last clock time (utc)", format: :utc_datetime)
            status(:boolean, "Clock status. Set to true when user clocks in and to false when he clocks out.")
          end

          example(%{
            id: 1,
            user_id: 1,
            time: "2017-02-04 11:24:45",
            status: false
          })
        end,
        ClockResponse: swagger_schema do
          title("ClockResponse")
          description("Response schema for single clock")
          property(:data, :Clock, "The clock details")
        end,
        ClocksResponse:
        swagger_schema do
          title("ClocksReponse")
          description("Response schema for multiple clocks")
          property(:data, Schema.array(:Clock), "The clocks details")
        end
    }
  end

  def working_times_definitions do
    %{
        WorkingTime: swagger_schema do
          title("WorkingTime")
          description("A working time entry for a given user")

          properties do
            id(:integer, "Working Time ID")
            user_id(:integer, "Associated user ID")
            start(:string, "Working time start time")
            end_(:string, "Workinng time end time", format: :email)
          end

          example(%{
            id: 1,
            user_id: 2,
            start: "2017-02-04 11:24:45",
            end: "2017-02-04 16:28:42",
          })
        end
    }
  end

  def team_definitions do
    %{
      Team: swagger_schema do
        title("Team")
        description("A team of employees managed by one or multiple managers.")

        properties do
          id(:integer, "Team ID")
          name(:string, "Team name")
        end

        example(%{
          id: 1,
          name: "Team A"
        })
      end,
      TeamDetailed: swagger_schema do
        title("TeamDetailed")
        description("A team of employees managed by one or multiple managers.")

        properties do
          id(:integer, "Team ID")
          name(:string, "Team name")
          employees(Schema.array(:User), "Team employees")
          managers(Schema.array(:User), "Team managers")
        end

        example(%{
          id: 1,
          name: "Team A",
          employees: [],
          managers: []
        })
      end
  }
  end

  def role_definitions do
    %{
      Permissions: swagger_schema do
        title("Permissions")
        description("List of existing permissions for each scope. Some additional restrictions are implemented with the team system.")

        properties do
          account(Schema.array(:string), "Account scope. Match authentified user", example: ["read", "update", "delete", "clock"])
          user(Schema.array(:string), "User scope. Match any user.", example: ["create", "read", "update", "delete", "clock", "role"])
          team(Schema.array(:string), "Team scope.", example: ["create", "read", "update", "delete", "clock"])
          clock(Schema.array(:string), "Clock scope. Admin only", example: ["read", "delete"])
          working_time(Schema.array(:string), "Working time scope.", example: ["create", "read", "update", "delete"])
          role(Schema.array(:string), "Role scope", example: ["read"])
        end
      end,
      Role: swagger_schema do
        title("Role")
        description("Role with associated permissions. Default roles are: Admin, General Manager, Manager and Employee")

        properties do
          id(:integer, "Role ID")
          name(:string, "Role name")
          permissions(Schema.ref(:Permissions), "Role permissions")
        end

        example(%{
          id: 4,
          name: "Employee",
          permissions: %{}
        })
      end,
      RoleDetailed: swagger_schema do
        title("RoleDetailed")
        description("Role with associated permissions. Default roles are: Admin, General Manager, Manager and Employee")

        properties do
          id(:integer, "Role ID")
          name(:string, "Role name")
          permissions(Schema.ref(:Permissions), "Role permissions")
          users(Schema.array(:User), "Users with the requested role")
        end

        example(%{
          id: 1,
          name: "Employee",
          users: []
        })
      end
  }
  end

end
