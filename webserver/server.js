const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const { spawn } = require("child_process");
const path = require("path");
const fs = require("fs");
const readline = require("readline");

const app = express();
const server = http.createServer(app);
const io = new Server(server);

// Serve frontend
app.use(express.static(path.join(__dirname, "public")));

// Helper function to read log file
async function readLastLines(maxLines = 500) {
  // Find Log File
  const files = fs.readdirSync("logs");
  const lockFile = files.find(file => file.endsWith(".lck"));
  const filePath = lockFile ? path.join("logs", lockFile.replace(/\.lck$/, '')) : "";

  if (!filePath || !fs.existsSync(filePath)) {
    return [];
  }

  const fileStream = fs.createReadStream(filePath);
  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
  });

  const lines = [];
  for await (const line of rl) {
    lines.push(line);
    if (lines.length > maxLines) {
      lines.shift();
    }
  }
  return lines;
}

// CHANGE THIS to your Hytale server command
const hytale = spawn(
  "java", ["-jar", "hytale/Server/HytaleServer.jar", "--assets", "hytale/Assets.zip"],
  { cwd: __dirname }
);

hytale.stdout.on("data", data => {
  io.emit("output", data.toString());
});

hytale.stderr.on("data", data => {
  io.emit("output", data.toString());
});

io.on("connection", async socket => {
  console.log("Client connected");

  // Send existing log history
  const history = await readLastLines(500);
  history.forEach(line => {
    socket.emit("output", line + "\n");
  });
  
  socket.on("command", cmd => {
    hytale.stdin.write(cmd + "\n");
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected");
  });
});

server.listen(3000, () => {
  console.log("Web console running at http://localhost:3000");
});
