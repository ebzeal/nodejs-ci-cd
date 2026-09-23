import http from "node:http";

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end("Hello from CI/CD Pipeline!\n");
});

server.listen(PORT, () => {
  console.log(`Server listening on http://localhost:${PORT}`);
});
