defmodule TimeManager.Roles.DefaultRoles do
  def all() do
    [
      %{
        name: "Admin",
        permissions: TimeManager.Roles.Permissions.all()
      },
      %{
        name: "General Manager",
        permissions: %{
          "account" => ["read", "update", "delete", "clock"],
          "user" => ["read", "delete", "clock", "role"],
          "team" => ["create", "read", "update", "delete", "clock"],
          "role" => ["read"]
        }
      },
      %{
        name: "Manager",
        permissions: %{
          "account" => ["read", "update", "delete", "clock"],
          "user" => ["read", "clock"],
          "team" => ["create", "read", "update", "delete", "clock"],
          "role" => ["read"]
        }
      },
      %{
        name: "Employee",
        permissions: %{
          "account" => ["read", "update", "delete", "clock"],
          "user" => ["read"],
          "role" => ["read"],
          "team" => ["read"]
        }
      }
    ]
  end
end
