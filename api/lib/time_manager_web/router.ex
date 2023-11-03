defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router
  use Pow.Phoenix.Router
  use Plug.ErrorHandler
  alias TimeManagerWeb.ErrorJSON, as: ErrorJSON

  defp handle_errors(conn, params) do
    conn |> json(ErrorJSON.handle_errors(params)) |> halt()
  end


  pipeline :api do
    plug :accepts, ["json"]
    plug TimeManager.Auth.AuthFlow, otp_app: :time_manager
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated,
    error_handler: TimeManagerWeb.AuthErrorHandler
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    # Public
    scope "/account" do
      post "/register", AccountController, :register
      post "/login", AccountController, :login
    end

    # Protected
    scope "/" do
      pipe_through :api_protected

      scope "/account" do
        get "/", AccountController, :show
        post "/clock", AccountController, :clock
        put "/", AccountController, :update
        patch "/", AccountController, :update
        delete "/", AccountController, :delete
      end

      resources "/roles", RoleController, only: [:index, :show]

      scope "/users" do
        resources "/", UserController, except: [:new, :edit, :create]
        post "/:userID/role/:roleID", UserController, :set_role
      end

      scope "/workingtimes" do
        resources "/", WorkingTimeController, except: [:new, :show, :create, :edit]
        get "/:userID", WorkingTimeController, :show_user_times
        get "/:userID/:id", WorkingTimeController, :show_user_time
        post "/:userID", WorkingTimeController, :create_user_time
      end

      scope "/clocks" do
        resources "/", ClockController, only: [:index, :delete]
        get "/:userID", ClockController, :get_user_clock
        post "/:userID", ClockController, :clock_user
      end
    end
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :time_manager,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Time Manager API"
      },
      definitions: TimeManagerWeb.SwaggerDefinitions.global_definitions
    }
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
