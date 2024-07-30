const typeDefs = /* GraphQL */ `
type MultiplyResponse {
    num: Float
    greeting: String
}

type Query {
    sum2(a: Int!, b: Int!): Int!
    helloWorld: String!
    hello(name: String!): String!
    minus(a: Int!, b: Int!): Int!

    multiply(x:Float!, y: Float!): MultiplyResponse

}
`;

export { typeDefs };
