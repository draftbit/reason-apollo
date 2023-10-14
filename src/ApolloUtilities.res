type operationDefinitionNode = {
  kind: string,
  operation: string,
}

@module("apollo-utilities")
external getMainDefinition: ReasonApolloTypes.documentNodeT => operationDefinitionNode =
  "getMainDefinition"
