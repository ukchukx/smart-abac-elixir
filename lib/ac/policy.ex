defmodule AC.Policy do
  @moduledoc """
  Specifies a Policy model for access control in the Swarm.

  This specification follows a number of requirements. Sometimes these requirements conflict with each other,
  so we try to flexibilize them and obtain a hybrid system, harmonizing theoretical and practical goals.

  * Enumerated Access Policy (EAP): the policy consists of an enumeration of terms, without logical expressions.
    When compared to Logical Access Policies (LAPs), some advantages of EAPs include the (general) notion of micro policies
    and ease of update.
  * Practical expressiveness: many models have been proposed for ABAC systems with varying degrees of expressiveness.
    For example, EAP has been proved to be theoretically equivalent to LAP with respect to expressive power.
    However, some approaches are not well suited for practical systems, such as the single-valued EAP modification
    introduced by Biswas et al. (2017), in which values were generated by the concatenation of all possible attributes
    from a multi-valued EAP. Thus, we go directly to a multi-value EAP proposal, in order to harmonize theoretical and practical needs.
    Such characteristics are desired in the Swarm, as they facilitate policy sharing and policy partitioning.
  * **TODO** Semantic annotations: in order to foster attribute interoperability and expand the reach of a policy,
    we envision that policies will use semantic tags. Thus, we allow a policy to be semantically tagged: beyond using
    semantic tags in the general listing of attributes, an optional field allows for placement of metadata with
    characteristics that describe the target environment where a policy is expected to operate.

  # Administrative Policies
  This section describes policies for controlling access over other policies.

  An administrative policy is just a normal policy, except that the `user_attrs` refer to a user with
  administrative power, and the `object_attrs` refer to a normal policy's `user_attrs` and `object_attrs`.

  For example:
  If a policy `P` has user attribute `u1` and object attribute `o2`, an administrative policy that allows
  editing this policy will have user attribute `a1` and object attributes `u1` and `o2`.

  The administrative policy model:
    * is based on the notion that there is an Administrator with
      total power, and sub-administrators with a subset of that power.
    * is inspired by the Policy Machine model, where the same model is used
      to govern the administrative actions that can be taken over the policies.

  ## Example policies:

  ```
  _admin_policy = %Policy{
    id: "...",
    name: "Top Admin Policy",
    user_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Administrator"}
    ],
    operations: ["all"],
    object_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Thing"}
    ]
  }

  %Policy{
    id: "...",
    name: "Admin Policy",
    user_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Manager"}
    ],
    operations: ["all"],
    object_attrs: [
      %Attr{data_type: "string", name: "Type", value: "AirConditioner"}
    ]
  }

  %Policy{
    id: "...",
    name: "Admin Policy",
    user_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Door"},
      %Attr{data_type: "range", name: "Trust", value: %{min: 4.5}}
    ],
    operations: ["all"],
    object_attrs: [
      %Attr{data_type: "string", name: "Type", value: "AirConditioner"}
    ]
  }

  # another option: using a special `admin_attr` entry
  %{
    id: "...",
    name: "Top Admin Policy",
    admin_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Administrator"}
    ],
    operations: ["all"],
    user_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Thing"}
    ],
    object_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Thing"}
    ]
  }
  %{
    id: "...",
    name: "Admin Policy",
    admin_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Manager"}
    ],
    operations: ["all"],
    user_attrs: [
      %Attr{data_type: "string", name: "Type", value: "Employee"}
    ],
    object_attrs: [
      %Attr{data_type: "string", name: "Type", value: "AirConditioner"}
    ]
  }
  ```
  """

  defstruct id: nil, name: "", user_attrs: [], operations: [], object_attrs: [], context_attrs: []

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          user_attrs: [Attr.t()],
          operations: [String.t()],
          object_attrs: [Attr.t()],
          context_attrs: [Attr.t()]
        }
end
