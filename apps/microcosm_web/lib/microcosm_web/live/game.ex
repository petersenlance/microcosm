defmodule MicrocosmWeb.LiveGameController do
  use MicrocosmWeb, :controller

  def game(conn, _) do
    IO.inspect("hi", label: "In the live-view controller")

    live_render(conn, MicrocosmWeb.LiveGameView, session: %{})
  end
end

defmodule MicrocosmWeb.LiveGameView do
  use Phoenix.LiveView
  alias Microcosm.Game

  def render(assigns) do
    ~L"""
    <p>Hello world</p>
    <h2>The Game of Life</h2>
    <div style="text-align: center">
    <button phx-click="restart" sytle="backgroud-color: black">Restart</button>
    <button phx-click="faster" sytle="backgroud-color: black">Faster</button>
    <button phx-click="slower" sytle="backgroud-color: black">Slower</button>
    <button phx-click="foo" sytle="backgroud-color: black">Change val</button>
    </div>
    <div>
    <p>My uuid is <%= @val %></p>
    <p>Current speed is <%= @timestep %> ms</p>
    </div>
    <table>
    <%=
    @board
    |> Enum.map(fn list -> %>
    <tr style="height: 1px;">
    <%= list
    |> Enum.map(fn {_, _, val} -> %>
    <%= case val do %>
    <% 1 -> %>
    <td style="background-color: green; padding: 5px; margin: 5px;"></td>
    <% 0 -> %>
    <td style="background-color: black; padding: 5px; margin: 5px"></td>
    <% end %>
    <% end) %>
    </tr>
    <% end) %>
    </table>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)
    {:ok, assign(socket, board: Game.start_game(), timestep: 700, val: Enum.random([:a, :b, :c]))}
  end

  def handle_info(:tick, socket) do
    socket.assigns.timestep |> IO.inspect(label: "the timestep")
    Process.send_after(self(), :tick, socket.assigns.timestep)
    {:noreply, assign(socket, board: Game.next_step())}
  end

  def handle_event("faster", _, socket) do
    {:noreply,
     update(socket, :timestep, fn
       speed when speed > 100 -> speed - 100
       speed -> speed
     end)}
  end

  def handle_event("slower", _, socket) do
    {:noreply, update(socket, :timestep, &(&1 + 100))}
  end

  def handle_event("restart", _, socket) do
    new_socket =
      socket
      |> update(:board, fn _ -> Game.start_game() end)

    {:noreply, new_socket}
  end

  def handle_event("foo", _, socket) do
    new_socket =
      socket
      |> update(:val, fn _ -> Enum.random([:x, :y, :z]) end)

    {:noreply, new_socket}
  end
end
