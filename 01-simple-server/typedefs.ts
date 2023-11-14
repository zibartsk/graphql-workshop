const typeDefs = /* GraphQL */ `
type Query {
    sum2(a: Int!, b: Int!): Int!
    helloWorld: String!
    hello(name: String!): String!
    minus(a: Int!, b: Int!): Int!
}
`;

export { typeDefs };
