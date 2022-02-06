open ReasonApolloTypes

@ocaml.doc("
 * Used on the client to rehydrate the cache using the initial data passed from the server
 * - e.g. window.__APOLLO_STATE__
 ")
type restoreData

@ocaml.doc("
 * Define the data to pass to the restore method that'll be used used to rehydrate client.
 * If you don't want to pass any data, simply return `Js_null_undefined.undefined`.
 ")
type inMemoryCacheRestoreData = Js.Nullable.t<restoreData>

@ocaml.doc("
 * CreateInMemoryCache
 * https://github.com/apollographql/apollo-client/tree/master/packages/apollo-cache-inmemory
 ")
@module("apollo-cache-inmemory")
@new
external /* Bind the InMemoryCache class */

apolloInMemoryCache: 'a => apolloCache = "InMemoryCache"

/* Bind the restore method */
@bs.send.pipe(: 't)
external restore: inMemoryCacheRestoreData => apolloCache = "restore"

/* Fragment matcher */
type fragmentMatcher

@module("apollo-cache-inmemory") @new
external introspectionFragmentMatcher: {..} => fragmentMatcher = "IntrospectionFragmentMatcher"

let createIntrospectionFragmentMatcher = (~data) =>
  introspectionFragmentMatcher({"introspectionQueryResultData": data})

/* Instantiate a new cache object */
@obj
external makeApolloInMemoryCacheParams: (
  ~dataIdFromObject: {..} => string=?,
  ~fragmentMatcher: fragmentMatcher=?,
) => _ = ""

let createInMemoryCache = (~dataIdFromObject=?, ~fragmentMatcher=?, ()) =>
  /* Apollo Client, looks for key in Object. Doesn't check if value is null */
  apolloInMemoryCache(makeApolloInMemoryCacheParams(~dataIdFromObject?, ~fragmentMatcher?))
