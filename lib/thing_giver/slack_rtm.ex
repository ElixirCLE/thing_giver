defmodule SlackRtm do
  use Slack
  import Ecto.Query
  alias ThingGiver.Repo

  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    respond_message(message, slack)
    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def respond_message(%{text: "give " <> _} = message, slack) do
    # IO.inspect(message)
    match = Regex.run(~r/give (<@.*>) (.*) (:.*:)/, message[:text])
    # IO.inspect(match)

    case match do
      [_, receiver, verb, thing] ->
        ThingGiver.Gifts.create_gift(%{
          giver: "<@#{message[:user]}>",
          receiver: receiver,
          verb: verb,
          thing: thing
        })

        send_message(
          "<@#{message[:user]}> gave #{receiver} #{verb} #{thing}",
          message.channel,
          slack
        )

      _ ->
        nil
    end
  end

  def respond_message(%{text: "what things does " <> message_tail} = message, slack) do
    match = Regex.run(~r/(<@.*>) have/, message_tail)

    case match do
      [_, subject] ->
        query = from gifts in ThingGiver.Gifts.Gift, where: gifts.receiver == ^subject

        gifts = Repo.all(query)
                |> Enum.map(&(&1.thing))
                |> Enum.join(" ")

        send_message("#{subject} has #{gifts}", message.channel, slack)

      _ ->
        nil
    end
  end

  def respond_message(_message, _slack), do: nil

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts("Sending your message, captain!")

    send_message(text, channel, slack)

    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}
end
