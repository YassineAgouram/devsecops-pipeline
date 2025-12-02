const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

// Route principale
app.get("/", (req, res) => {
    res.send("<h1>☕ the App successfully running !</h1>");
});

// API simple
app.get("/api/health", (req, res) => {
    res.json({ status: "OK", app: "Starbucks App", timestamp: Date.now() });
});

app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
