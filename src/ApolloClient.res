open ReasonApolloTypes

type queryObj = {
  query: ReasonApolloTypes.queryString,
  variables: Js.Json.t,
}

type mutationObj = {
  mutation: ReasonApolloTypes.queryString,
  variables: Js.Json.t,
}

type generatedApolloClient = {
  query: @meth (queryObj => Js.Promise.t<ReasonApolloQuery.renderPropObjJS>),
  mutate: @meth (mutationObj => Js.Promise.t<ReasonApolloMutation.renderPropObjJS>),
  resetStore: @meth (unit => Js.Promise.t<unit>),
}

type fetch

type linkOptions = {
  uri: string,
  includeExtensions: Js.Nullable.t<bool>,
  fetch: Js.Nullable.t<fetch>,
  headers: Js.Nullable.t<Js.Json.t>,
  credentials: Js.Nullable.t<string>,
  fetchOptions: Js.Nullable.t<Js.Json.t>,
}

type uploadLinkOptions = {
  uri: Js.Nullable.t<string>,
  fetch: Js.Nullable.t<fetch>,
  fetchOptions: Js.Nullable.t<{.}>,
  credentials: Js.Nullable.t<string>,
  headers: Js.Nullable.t<Js.Json.t>,
  includeExtensions: Js.Nullable.t<bool>,
}

type apolloClientObjectParam = {
  link: apolloLink,
  cache: apolloCache,
  ssrMode: option<bool>,
  ssrForceFetchDelay: option<int>,
  connectToDevTools: option<bool>,
  queryDeduplication: option<bool>,
}
@module("apollo-client") @new
external createApolloClientJS: apolloClientObjectParam => generatedApolloClient = "ApolloClient"

@module("graphql-tag") external gql: ReasonApolloTypes.gql = "default"

// [@bs.obj]
// external apolloClientObjectParam:
//   (
//     ~link: apolloLink,
//     ~cache: apolloCache,
//     ~ssrMode: bool=?,
//     ~ssrForceFetchDelay: int=?,
//     ~connectToDevTools: bool=?,
//     ~queryDeduplication: bool=?
//   ) =>
//   _ =
//   "";
// type apolloClientObjectParam = {
//   link: apolloLink,
//   cache: apolloCache,
//   ssrMode: option(bool),
//   ssrForceFetchDelay: option(int),
//   connectToDevTools: option(bool),
//   queryDeduplication: option(bool),
// };
module ReadQuery = (Config: ReasonApolloTypes.Config) => {
  type readQueryOptions = {
    query: ReasonApolloTypes.queryString,
    variables: Js.Nullable.t<Js.Json.t>,
  }
  type response = option<Config.t>
  @send
  external readQuery: (generatedApolloClient, readQueryOptions) => Js.Nullable.t<Js.Json.t> =
    "readQuery"

  let graphqlQueryAST = gql(. Config.query)
  let apolloDataToRecord: Js.Nullable.t<Js.Json.t> => response = apolloData =>
    Js.Nullable.toOption(apolloData)->Belt.Option.map(Config.parse)

  let make = (~client, ~variables: option<Js.Json.t>=?, ()) =>
    readQuery(
      client,
      {query: graphqlQueryAST, variables: Js.Nullable.fromOption(variables)},
    )->apolloDataToRecord
}

module WriteQuery = (Config: ReasonApolloTypes.Config) => {
  type writeQueryOptions = {
    query: ReasonApolloTypes.queryString,
    variables: Js.Nullable.t<Js.Json.t>,
    data: Config.t,
  }
  @send
  external writeQuery: (generatedApolloClient, writeQueryOptions) => unit = "writeQuery"

  let graphqlQueryAST = gql(. Config.query)

  let make = (~client, ~variables: option<Js.Json.t>=?, ~data: Config.t, ()) =>
    writeQuery(
      client,
      {
        query: graphqlQueryAST,
        variables: Js.Nullable.fromOption(variables),
        data: data,
      },
    )
}
