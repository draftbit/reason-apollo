open ReasonApolloTypes;

/**
 * Describe your data object shape. Usually you have following keys:
 * - "__typename": string
 * - "id": string
 */
type dataObject;

/**
 * Used on the client to rehydrate the cache using the initial data passed from the server
 * - e.g. window.__APOLLO_STATE__
 */
type restoreData;

/**
 * Define the object to pass to the InMemoryCache constructor.
 * If you don't want to pass any object, simply return `Js_null_undefined.undefined`.
 */
let inMemoryCacheObject:
  /* TODO: define missing fields */
  Js.Nullable.t({. "dataIdFromObject": dataObject => string});

/**
 * Define the data to pass to the restore method that'll be used used to rehydrate client.
 * If you don't want to pass any data, simply return `Js_null_undefined.undefined`.
 */
type inMemoryCacheRestoreData = Js.Nullable.t(restoreData);

/**
 * CreateInMemoryCache
 * https://github.com/apollographql/apollo-client/tree/master/packages/apollo-cache-inmemory
 */

/* Bind the InMemoryCache class */
[@bs.module "apollo-cache-inmemory"] [@bs.new]
external createInMemoryCache : inMemoryCacheObject => apolloCache =
  "InMemoryCache";

/* Bind the restore method */
[@bs.send.pipe : 't] external restore : inMemoryCacheRestoreData => apolloCache = "restore";

/* Instantiate a new cache object */
let createInMemoryCache = (inMemoryCacheObject) => apolloInMemoryCache(inMemoryCacheObject);