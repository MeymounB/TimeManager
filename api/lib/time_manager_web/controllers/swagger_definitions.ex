defmodule TimeManagerWeb.SwaggerDefinitions do
  use PhoenixSwagger

  def global_definitions do
    %{
      ErrorReason: swagger_schema do
        title("ErrorReason")
        description("An error")

        properties do
          _type(:string, "Errror type", required: true)
          message(:string, "Error message", required: true)
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
          reason(Schema.ref(:ErrorReason), "Error reason", required: true)
        end
      end,
      UnprocessableEntityResponse: swagger_schema do
        title("UnprocessableEntityResponse")
        description("An action was requested to the server but the input was invalid")

        properties do
          errors(%Schema{type: :object}, "Error reasons. An entry for each invalid parameters with an array of reasons.", required: true)
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
          description("A user of the app")

          properties do
            id(:integer, "User ID")
            username(:string, "User name", required: true)
            email(:string, "Email address", format: :email, required: true)
          end

          example(%{
            id: 1,
            username: "Joe",
            email: "joe@gmail.com"
          })
        end,
        UserDetailed: swagger_schema do
          title("UserDetailed")
          description("A user of the app with its associations")

          properties do
            id(:integer, "User ID")
            username(:string, "User name", required: true)
            email(:string, "Email address", format: :email, required: true)
            clock(Schema.ref(:Clock), "User clock", "x-nullable": true)
            working_times(Schema.array(:Clock), "User working times")
          end

          example(%{
            id: 1,
            username: "Joe",
            email: "joe@gmail.com",
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
          property(:user, Schema.ref(:User), "The user details")
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
            time(:string, "Last clock time (utc)", format: :utc_datetime, required: true)
            status(:boolean, "Clock status. Set to true when user clocks in and to false when he clocks out.", required: true)
          end

          example(%{
            id: 1,
            user_id: 1,
            time: "2017-02-04 11:24:45",
            status: false
          })
        end
    }
  end

  def working_times_definitions do
    %{
        WorkingTime: swagger_schema do
          title("WorkingTime")
          description("A working time entry for a given user")

          properties do
            id(:integer, "User ID")
            user_id(:integer, "Associated user ID")
            start(:string, "User name", required: true)
            end_(:string, "Email address", format: :email, required: true)
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

end
