defmodule ABACthem.PDPv2 do
  use ABACthem.LogDecorator
  alias ABACthem.Types

  @doc """
  Returns whether or not any of the `policies` allow the `request` to be executed.
  """
  def authorize(request, policies) do
    policies
    |> Enum.any?(fn policy ->
      match_rules(request, policy.privileges) #&& !match_rules(request, policy.prohibitions)
    end)
  end

  @doc """
  Returns whether or not any of the `rules` match the `request` to be executed.
  """
  def match_rules(request, rule) do
    match_operations(request.operations, rule.operations) &&
      match_attrs(request.subject, rule.subject) &&
      match_attrs(request.object, rule.object) &&
      match_attrs(request.context, rule.context)
  end

  @doc """
  Tests whether the request attributes are allowed by a policy.
  """
  Application.get_env(:abac_them, :debug_pdp) && @decorate log(:debug)
  def match_attrs(request_attrs, policy_attrs) do
    policy_attrs
    |> Enum.all?(fn policy_attr ->
      policy_attr = Types.infer_type(policy_attr)
      Enum.any?(request_attrs, &match_attr(policy_attr.data_type, &1, policy_attr))
    end)
  end

  @doc """
  Checks whether a number, provided by the request, is within a range, specified in the policy.
  """
  def match_attr("range", {req_name, req_value}, policy_attr) do
    policy_attr.name == req_name and match_range(req_value, policy_attr.value)
  end

  @doc """
  Compares a number, provided by the request, with another number, specified in the policy.
  """
  def match_attr("number", {req_name, req_value}, policy_attr) do
    policy_attr.name == req_name and policy_attr.value == req_value
  end

  @doc """
  Compares *container* attributes, from the request, against string attributes defined in the policy.
  """
  def match_attr("string", {req_name, req_values}, policy_attr) when is_list(req_values) do
    req_values
    |> Enum.any?(fn req_value ->
      match_attr("string", {req_name, req_value}, policy_attr)
    end)
  end

  @doc """
  Compares a string, provided by the request, against another string, specified in the policy.
  """
  def match_attr("string", {req_name, req_value}, policy_attr) do
    policy_attr.name == req_name and policy_attr.value == req_value
  end

  @doc """
  Compares a object.
  """
  def match_attr("object", {req_name, req_value}, policy_attr) do
    policy_attr.name == req_name && match_attrs(req_value, policy_attr.value)
  end

  @doc """
  Match a numerical value against a range defined as a map.
  """
  def match_range(value, range) do
    case range do
      %{min: min, max: max} ->
        value >= min && value <= max

      %{min: min} ->
        value >= min

      %{max: max} ->
        value <= max

      _ ->
        false
    end
  end

  @doc """
  Tests whether the request operations are allowed by a policy.

  Returns true when the set `request_ops` is a subset of `policy_ops`.
  """
  Application.get_env(:abac_them, :debug_pdp) && @decorate log(:debug)
  def match_operations([], _policy_ops), do: false
  def match_operations(_request_ops, []), do: false
  def match_operations(_request_ops, ["all"]), do: true

  def match_operations(request_ops, policy_ops) do
    request_ops
    |> Enum.all?(&(&1 in policy_ops))
  end
end