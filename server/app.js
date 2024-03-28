const express = require("express");
const bodyParser = require("body-parser");
const app = express();

const http = require("http").createServer(app);
const io = require("socket.io")(http);
const PORT = 5001;

// Middleware to parse JSON data
app.use(bodyParser.json());

// Serve static HTML files
app.use(express.static("public"));

app.options("*", (req, res) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "*");
  res.header("Access-Control-Allow-Methods", "*");
  res.sendStatus(200);
});

// Enable CORS for all methods
app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "*");
  res.header("Access-Control-Allow-Methods", "*");
  next();
});

let voteCount = {
  left: 0,
  right: 0,
};

// GET route for the waiting room
app.get("/waiting_room", (req, res) => {
  res.sendFile(__dirname + "/public/waiting_room.html");
});

// GET route for the voting room
app.get("/voting_room", (req, res) => {
  res.sendFile(__dirname + "/public/voting_room.html");
});

app.get("/api/get-votes", (req, res) => {
  res.json(voteCount);
});

app.get("/api/get-winner", (req, res) => {
  const { left, right } = voteCount;
  let winner = "";

  if (left > right) {
    res.json({ winnerCode: 1, type: eventType });
    winner = "Left wins!";
  } else if (right > left) {
    res.json({ winnerCode: -1, type: eventType });
    winner = "Right wins!";
  } else {
    res.json({ winnerCode: 0, type: eventType });
    winner = "Both wins!";
  }
  voteCount.left = voteCount.right = 0;
  io.emit("get-winner", winner);
});
var eventType;
// POST route for triggering the redirect
app.post("/api/trigger-redirect", (req, res) => {
  const data = req.body.value;
  console.log(data);
  eventType = data;
  // Assuming a successful POST request triggers the redirect
  res.json({ success: true });
  io.emit("redirect-voting-room", data);
});

// POST route for handling votes
app.post("/api/vote", (req, res) => {
  const { option } = req.body;

  if (option === "Left") {
    voteCount.left++;
    console.log("left voted\n", voteCount.left);
  } else if (option === "Right") {
    voteCount.right++;
    console.log("right voted\n", voteCount.right);
  }

  // Emit updated counters to all clients
  io.emit("update-counters", voteCount);

  res.json({ success: true });
});

// Socket.IO connection handling
io.on("connection", (socket) => {
  console.log("A user connected");

  // Listen for a redirectment
  socket.on("redirect-voting-room", () => {
    console.log("Redirecting to the Voting Room");
    // Broadcast the redirect event to all connected clients
    io.emit("redirect-voting-room");

    socket.emit("update-counters", voteCount);
  });
});

// Start the Server
http.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
