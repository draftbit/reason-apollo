open ApolloClient

@module("react-apollo") @react.component
external make: (~client: generatedApolloClient, ~children: React.element) => React.element =
  "ApolloProvider"
