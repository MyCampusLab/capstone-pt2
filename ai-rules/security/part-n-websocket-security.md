# WebSocket Security (Mandatory if using WebSocket)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  WebSocket Security

**Requirements:**
1. **Authentication:**
   - Authenticate WebSocket connections (token in query param atau first message)
   - Validate origin header (prevent CSRF)
   - Use `wss://` (TLS) di production

2. **Authorization:**
   - Check permissions per message (not just connection)
   - Implement rate limiting per connection
   - Validate message format (JSON schema)

3. **Message Security:**
   - Sanitize all incoming messages (prevent XSS)
   - Limit message size (prevent DoS)
   - Implement ping/pong untuk connection health

**Implementation:**
```javascript
// Server-side WebSocket security
const wss = new WebSocketServer({ 
  port: 8080,
  verifyClient: (info, callback) => {
    // 1. Check origin
    const allowedOrigins = ['https://app.example.com'];
    if (!allowedOrigins.includes(info.origin)) {
      return callback(false, 403, 'Forbidden');
    }
    
    // 2. Authenticate via token
    const url = new URL(info.req.url, 'http://localhost');
    const token = url.searchParams.get('token');
    const user = verifyToken(token);
    
    if (!user) {
      return callback(false, 401, 'Unauthorized');
    }
    
    // 3. Attach user to request
    info.req.user = user;
    callback(true);
  }
});

wss.on('connection', (ws, req) => {
  const user = req.user;
  
  // 4. Rate limiting per connection
  let messageCount = 0;
  const rateLimit = setInterval(() => { messageCount = 0; }, 1000);
  
  ws.on('message', (data) => {
    // 5. Check rate limit
    if (++messageCount > 100) {
      ws.close(1008, 'Rate limit exceeded');
      return;
    }
    
    // 6. Validate message size
    if (data.length > 1024 * 1024) { // 1MB max
      ws.close(1009, 'Message too large');
      return;
    }
    
    // 7. Parse and validate message
    let message;
    try {
      message = JSON.parse(data);
      // Validate against schema
    } catch (e) {
      ws.send(JSON.stringify({ error: 'Invalid message format' }));
      return;
    }
    
    // 8. Check authorization per message
    if (!canPerformAction(user, message.action)) {
      ws.send(JSON.stringify({ error: 'Unauthorized' }));
      return;
    }
    
    // 9. Process message (sanitize output)
    const response = processMessage(message);
    ws.send(JSON.stringify(response));
  });
  
  ws.on('close', () => {
    clearInterval(rateLimit);
  });
});
```

---

Kembali ke [Index](./README.md)
