defmodule MicrocosmWeb.GameController do
  use MicrocosmWeb, :controller
  alias Microcosm.Game

  def start(conn, _params) do
    board = Game.start_game()
    render(conn, "board.html", board: board)
  end

  def next_step(conn, _params) do
    board = Game.next_step()
    render(conn, "board.html", board: board)
  end
end
