# GraphQL Security (Mandatory if using GraphQL)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  GraphQL-Specific Security

**Vulnerabilities:**
1. **Introspection Query:** Exposes schema (disable di production)
2. **Deep Nesting:** DoS via deeply nested queries
3. **Batch Attacks:** Multiple queries dalam 1 request
4. **Field-Level Authorization:** Bypass via nested fields

**Mitigations:**
```javascript
// 1. Disable introspection di production
const server = new ApolloServer({
  schema,
  introspection: process.env.NODE_ENV !== 'production',
});

// 2. Query complexity limit
const depthLimit = require('graphql-depth-limit');
const complexityLimit = require('graphql-query-complexity');

const server = new ApolloServer({
  schema,
  validationRules: [
    depthLimit(5), // Max nesting depth
    complexityLimit({
      maxComplexity: 1000,
      variables: {},
    }),
  ],
});

// 3. Rate limiting
const rateLimit = require('express-rate-limit');
app.use('/graphql', rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
}));

// 4. Field-level authorization
const resolvers = {
  Query: {
    user: async (parent, args, context) => {
      // Check if user can access this field
      if (!context.user.hasPermission('user:read', args.id)) {
        throw new Error('Unauthorized');
      }
      return await getUser(args.id);
    },
  },
};

// 5. Persisted queries (prevent arbitrary queries)
// Client sends query ID, server executes pre-approved query
```

---

Kembali ke [Index](./README.md)
