defmodule TimeManagerWeb.SwaggerDefinitions do
  use PhoenixSwagger
  alias PhoenixSwagger.Path

  def json_path(%Path.PathObject{} = path) do
    path
    |> Path.produces("application/json")
    |> Path.consumes("application/json")
  end

  def protected_path(%Path.PathObject{} = path) do
    path
    |> Path.security([%{"bearerToken" => []}])
    |> Path.response(401, "Unauthorized", Schema.ref(:UnauthorizedResponse))
    |> Path.response(403, "Forbidden", Schema.ref(:ForbiddenResponse))
  end

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
      UnauthorizedResponse: swagger_schema do # 401
        title("UnauthorizedResponse")
        description("An action was requested to the server but the user is not authenticated")

        properties do
          errors(%Schema{type: :object}, "Errors object containing error message.")
        end

        example(%{
          errors: %{
            message: "The user is not authenticated"
          }
        })
      end,
      ForbiddenResponse: swagger_schema do # 403
        title("ForbiddenResponse")
        description("An action was requested to the server with an authentified user but the user doesn't have enough permissions")

        properties do
          errors(%Schema{type: :object}, "Errors object containing error message.")
        end

        example(%{
          errors: %{
            message: "The user has insufficient permissions"
          }
        })
      end,
      NotFoundResponse: swagger_schema do # 404
        title("NotFoundResponse")
        description("A resource was requested but the server was unavailable to find it")

        properties do
          reason(:ErrorReason, "Error reason")
        end
      end,
      UnprocessableEntityResponse: swagger_schema do # 422
        title("UnprocessableEntityResponse")
        description("An action was requested to the server but the input was invalid")

        properties do
          error(%Schema{type: :object}, "Error reasons. An entry for each invalid parameters with an array of reasons.")
        end

        example(%{
          error: %{
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
              time: "2023-02-04 11:24:45",
              status: false
            },
            working_times: []
          })
        end,
        UserRequest: swagger_schema do
          title("UserRequest")
          description("PUT/PATCH body for updating a user (can be partial)")
          property(:user, Schema.ref(:User), "The user details")

          example(%{
            user: %{
              firstname: "Joe",
              lastname: "Doe",
              email: "joe@gmail.com",
              role_id: 1,
              custom_permissions: %{}
            }
          })
        end,
        UserResponse: swagger_schema do
          title("UserResponse")
          description("Response schema for single user")
          property(:data, Schema.ref(:UserDetailed), "The user details")
        end,
        UsersResponse:
        swagger_schema do
          title("UsersReponse")
          description("Response schema for multiple users")
          property(:data, Schema.array(:User), "The users list")
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
            time: "2023-02-04 11:24:45",
            status: false
          })
        end,
        ClockResponse: swagger_schema do
          title("ClockResponse")
          description("Response schema for single clock")
          property(:data, Schema.ref(:Clock), "The clock details")
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
            start(:string, "Working time start time", format: :utc_datetime)
            end_(:string, "Workinng time end time", format: :utc_datetime)
          end

          example(%{
            id: 1,
            user_id: 2,
            start: "2023-02-04 11:24:45",
            end: "2023-02-04 16:28:42",
          })
        end,
        UserWorkingTimeRequest: swagger_schema do
          title("UserWorkingTimeRequest")
          description("Request body when creating a user working time")

          properties do
            start(:string, "Working time start time", format: :utc_datetime)
            end_(:string, "Workinng time end time", format: :utc_datetime)
          end

          example(%{
            working_time: %{
              start: "2023-02-04 11:24:45",
              end: "2023-02-04 16:28:42",
            }
          })
        end,
        WorkingTimeRequest: swagger_schema do
          title("WorkingTimeRequest")
          description("Request body when creating a user working time")

          properties do
            user_id(:integer, "Associated user id")
            start(:string, "Working time start time", format: :utc_datetime)
            end_(:string, "Workinng time end time", format: :utc_datetime)
          end

          example(%{
            working_time: %{
              user_id: 1,
              start: "2023-02-04 11:24:45",
              end: "2023-02-04 16:28:42",
            }
          })
        end,
        WorkingTimeResponse: swagger_schema do
          title("WorkingTimeResponse")
          description("Response schema for single working time")
          property(:data, Schema.ref(:WorkingTime), "The working time details")
        end,
        WorkingTimesResponse:
        swagger_schema do
          title("WorkingTimesResponse")
          description("Response schema for multiple working times")
          property(:data, Schema.array(:WorkingTime), "The working times list")
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
      end,
      TeamRequest: swagger_schema do
        title("TeamRequest")
        description("A team request for team creation.")

        properties do
          name(:string, "Team name")
        end

        example(%{
          team: %{
            name: "Team A",
          }
        })
      end,
      TeamResponse: swagger_schema do
        title("TeamResponse")
        description("Response schema for single team")
        property(:data, Schema.ref(:TeamDetailed), "The team details")
      end,
      TeamsResponse: swagger_schema do
        title("TeamsResponse")
        description("Response schema for multiple teams")
        property(:data, Schema.array(:Team), "The teams list")
      end,
      TeamClockResponse: swagger_schema do
        title("TeamClockResponse")
        description("Response schema for a team clock")
        property(:data, Schema.array(:Clock), "The team users' clocks'")
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
      end,
      RoleResponse: swagger_schema do
        title("RoleResponse")
        description("Response schema for single role")
        property(:data, Schema.ref(:Role), "The role details")
      end,
      RolesResponse:
      swagger_schema do
        title("RolesResponse")
        description("Response schema for multiple roles")
        property(:data, Schema.array(:Role), "The roles list")
      end
  }
  end

  def account_definitions do
    %{
      RegisterRequest: swagger_schema do
        title("RegisterRequest")
        description("Account registration request")

        properties do
          firstname(:string, "User first name", required: true)
          lastname(:string, "User last name", required: true)
          email(:string, "User email", required: true)
          password(:string, "User password. You should consider sending a hashed password to avoid man in the middle issues.", required: true)
          password_confirmation(:string, "User password confirmation (must equal password property)", required: true)
        end

        example(%{
          firstname: "toto",
          lastname: "tata",
          email: "toto2@epitech.eu",
          password: "12345678",
          password_confirmation: "12345678"
        })
      end,
      AuthSuccessResponse: swagger_schema do
        title("AuthSuccessResponse")
        description("Authentification success response")

        properties do
          access_token(:string, "User access token. Must be send in the Authorization header as a bearer token.")
          refresh_token(:string, "User refresh token. Use it on /api/account/refresh to renew the access token when it expires.")
        end

        example(%{
          access_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6NjAwMDE2OTkzOTAxMzAsImlhdCI6MTY5OTM5MDczMCwiaXNzIjoiSm9rZW4iLCJqdGkiOiIydWFuNW5jOGVxcWhnMWZ0NGMwMDAxbzEiLCJuYmYiOjE2OTkzOTA3MzAsInVzZXJfaWQiOjR9.w0PMJ--hYo81YrgiQ8n2rJk5maAEfiF3lxGo8ddCnp0",
          refresh_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTcwMjA2OTEzMCwiaWF0IjoxNjk5MzkwNzMwLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJ1YW41bmM2ZzZvbmsxZnQ0YzAwMDFuMSIsIm5iZiI6MTY5OTM5MDczMCwidXNlcl9pZCI6NH0.ZQwBjo02loJkND_GbbR-slmh0V1ufkU1zoDB36A5frA",
        })
      end,
      RefreshSuccessResponse: swagger_schema do
        title("RefreshSuccessResponse")
        description("Access token refresh response")

        properties do
          access_token(:string, "User access token. Must be send in the Authorization header as a bearer token.")
        end

        example(%{
          access_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6NjAwMDE2OTkzOTAxMzAsImlhdCI6MTY5OTM5MDczMCwiaXNzIjoiSm9rZW4iLCJqdGkiOiIydWFuNW5jOGVxcWhnMWZ0NGMwMDAxbzEiLCJuYmYiOjE2OTkzOTA3MzAsInVzZXJfaWQiOjR9.w0PMJ--hYo81YrgiQ8n2rJk5maAEfiF3lxGo8ddCnp0",
        })
      end,
      RegisterError: swagger_schema do
        title("RegisterError")
        description("Register error content")

        properties do
          errors(%Schema{type: :object}, "Error reasons. An entry for each invalid parameters with an array of reasons.")
          message(:string, "General error message")
        end

        example(%{
          errors: %{
            email: ["has alrady been taken"]
          },
          message: "Couldn't create user"
        })
      end,
      RegisterFailureResponse: swagger_schema do
        title("RegisterFailureResponse")
        description("Register failure response")

        properties do
          error(Schema.ref(:RegisterError), "Registration error details")
        end
      end,
      LoginRequest: swagger_schema do
        title("LoginRequest")
        description("Account login request")

        properties do
          email(:string, "User email", required: true)
          password(:string, "User password. You should consider sending a hashed password to avoid man in the middle issues.", required: true)
        end

        example(%{
          email: "toto2@epitech.eu",
          password: "12345678",
        })
      end
    }
  end

end
