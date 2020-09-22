ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(CarsApp.Repo, :manual)

if function_exported?(ExUnit, :after_suite, 1) do
  ExUnit.after_suite(fn _ -> Mix.shell(Mix.Shell.IO) end)
end
