defmodule SlackRtm do
  use Slack

  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    respond_message(message, slack)
    {:ok, state}
  end

  def respond_message(message, slack) do
    # IO.inspect(message)
    match = Regex.run(~r/[g|G]ive (<@.*>) (.*) (:.*:)/, message[:text])
    IO.inspect(match)

    case match do
      [_,receiver,verb ,thing] ->
        send_message("<@#{message[:user]}> gave #{receiver} #{verb} #{thing}", message.channel, slack)
      _ ->
        send_message("#{message[:text]} and you suck at programing", message.channel, slack)
    end
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts("Sending your message, captain!")

    send_message(text, channel, slack)

    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}
end
