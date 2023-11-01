# Simple GraphQL Server

```bash
# enter this folder
cd /workspaces/graphql-workshop/01-simple-server
#
./server.ts
# open http://127.0.0.1:8000/graphql
```

Continue in GraphQL Playground of your new service at [http://127.0.0.1:8000/graphql](http://127.0.0.1:8000/graphql)

Review code of our server:
* `typedefs.ts` - contains GraphQL SDL definition what API can do
* `resolvers.ts` - is implemantation handling these queries


Now implementing `sum2` - call taking two numbers and returning sum would be relatively easy to implement.

We start from SDL schema extension with new query in `typedefs.ts`
```
type Query {
    sum2(a: Int!, b: Int!): Int!
    helloWorld: String!
    hello(name: String!): String!
}
```

API has resolver implementing your query in `resolvers.ts`
```typescript
function helloWorld() {
  return "Hello Deno!";
}

// deno-lint-ignore no-explicit-any
function hello(_: any, { name }: { name: string }) {
  return `Hello ${name}!`;
}

// deno-lint-ignore no-explicit-any
function sum2(_: any, { a, b }: { a: number, b: number }) {
  return a+b;
}

const resolvers = {
  Query: {
    sum2,
    helloWorld,
    hello
  },
};

export { resolvers };

```