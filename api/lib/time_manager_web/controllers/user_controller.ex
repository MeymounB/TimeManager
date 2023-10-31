defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  def swagger_definitions do
    TimeManagerWeb.SwaggerDefinitions.user_definitions()
  end

  swagger_path(:index) do
    summary("List Users")
    description("List all users in the database")

    response(200, "OK", Schema.ref(:UsersResponse),
      example: %{
        data: [
          %{
            id: 1,
            name: "Joe",
            email: "Joe6@mail.com",
          },
          %{
            id: 2,
            name: "Jack",
            email: "Jack7@mail.com",
          }
        ]
      }
    )
  end
  def index(conn, params) do
    users = Users.list_users(params)
    render(conn, :index, users: users)
  end

  swagger_path(:create) do
    summary("Create user")
    description("Creates a new user")

    parameter(:user, :body, Schema.ref(:UserRequest), "The user details",
      example: %{
        user: %{name: "Joe", email: "Joe1@mail.com"}
      }
    )

    response(201, "User created OK", Schema.ref(:UserResponse),
      example: %{
        data: %{
          id: 1,
          name: "Joe",
          email: "Joe2@mail.com"
        }
      }
    )
  end
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  swagger_path(:show) do
    summary("Show User")
    description("Show a user by ID")
    produces("application/json")
    parameter(:id, :path, :integer, "User ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:UserResponse),
      example: %{
        data: %{
          id: 123,
          name: "Joe",
          email: "Joe3@mail.com",
          clock: nil,
          working_times: []
        }
      }
    )
  end
  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  swagger_path(:update) do
    summary("Update user")
    description("Update attributes of a user")

    parameters do
      id(:path, :integer, "User ID", required: true, example: 3)

      user(:body, Schema.ref(:UserRequest), "The user details",
        example: %{
          user: %{name: "Joe", email: "joe4@mail.com"}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:UserResponse),
      example: %{
        data: %{
          id: 3,
          name: "Joe",
          email: "Joe5@mail.com"
        }
      }
    )
  end
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  swagger_path(:delete) do
    PhoenixSwagger.Path.delete("/api/users/{id}")
    summary("Delete User")
    description("Delete a user by ID")
    parameter(:id, :path, :integer, "User ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
  end
  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
