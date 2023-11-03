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
        }
      },
      %{
        name: "Manager",
        permissions: %{
          "account" => ["read", "update", "delete", "clock"],
          "user" => ["read", "clock"],
          "team" => ["create", "read", "update", "delete", "clock"],
        }
      },
      %{
        name: "Employee",
        permissions: %{
          "account" => ["read", "update", "delete", "clock"],
        }
      }
    ]
  end
end
