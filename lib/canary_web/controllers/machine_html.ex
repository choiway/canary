defmodule CanaryWeb.MachineHTML do
  use CanaryWeb, :html

  embed_templates "machine_html/*"

  @doc """
  Renders a machine form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def machine_form(assigns)
end
