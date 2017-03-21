defmodule Server do
  @moduledoc """
  Documentation for Server.
  """
  use Application

  def start(_type, _args) do
    Server.Supervisor.start_link
  end

end
