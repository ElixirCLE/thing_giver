defmodule ThingGiver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    Slack.Bot.start_link(SlackRtm, [], "xoxb-555264486627-556478095367-cTUJgbS8urgxah44pC04H3g4")
    children = [
      # Start the Ecto repository
      ThingGiver.Repo,
      # Start the endpoint when the application starts
      ThingGiverWeb.Endpoint
      # Starts a worker by calling: ThingGiver.Worker.start_link(arg)
      # {ThingGiver.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ThingGiver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ThingGiverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
