defmodule CanaryWeb.PageHTML do
  use CanaryWeb, :html
  import Phoenix.Component 

  embed_templates "page_html/*"
end
