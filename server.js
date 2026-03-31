const express = require("express");
const cors = require("cors");
const mysql = require("mysql2");

const app = express();

console.log("🔥 NEW VERSION DEPLOYED");

// ✅ FIXED CORS
app.use(cors({
  origin: "https://frontend-portfolio-obq3.onrender.com",
  methods: ["GET", "POST"]
}));

app.use(express.json());

// ✅ DB CONNECTION (uses Render env variables)
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

// 🔍 Debug
console.log("DB HOST:", process.env.DB_HOST);
console.log("DB PORT:", process.env.DB_PORT);

// ✅ CONNECT
db.connect(err => {
  if (err) {
    console.error("DB ERROR:", err);
  } else {
    console.log("MySQL Connected ✅");
  }
});

// ✅ ROOT ROUTE
app.get("/", (req, res) => {
  res.send("Backend running 🚀");
});

// ✅ CONTACT ROUTE
app.post("/contact", (req, res) => {
  const { name, email, message } = req.body;

  console.log("Incoming data:", req.body);

  const sql = "INSERT INTO messages (name, email, message) VALUES (?, ?, ?)";

  db.query(sql, [name, email, message], (err, result) => {
    if (err) {
      console.error("INSERT ERROR:", err);
      return res.status(500).send("DB Error");
    }

    res.send("Message saved!");
  });
});

// ✅ START SERVER
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log("Server running on port", PORT);
});