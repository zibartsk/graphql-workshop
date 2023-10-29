
function helloWorld() {
  return "Hello Deno!";
}

// deno-lint-ignore no-explicit-any
function hello(_: any, { name }: { name: string }) {
  return `Hello ${name}!`;
}

const resolvers = {
  Query: {
    helloWorld,
    hello
  },
};

export { resolvers };
