defmodule MicrocosmWeb.PageController do
  use MicrocosmWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
