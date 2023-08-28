defimpl Phoenix.Param, for: TypeID do
  def to_param(type_id), do: TypeID.to_string(type_id)
end
