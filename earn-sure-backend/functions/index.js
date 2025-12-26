const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();

// Initialize Firebase Admin SDK
admin.initializeApp();

const app = express();

// ==================== MIDDLEWARE ====================
app.use(cors({
  origin: true,
  credentials: true,
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ==================== MONGODB CONNECTION ====================
const MONGODB_URI = process.env.MONGODB_URI ||
  (functions.config().mongo && functions.config().mongo.uri);

if (!MONGODB_URI) {
  console.error("MONGODB_URI not configured");
}

mongoose.connect(MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log("MongoDB Connected"))
  .catch((err) => console.error("MongoDB Error:", err));

// ==================== ROUTE IMPORTS ====================
const authRoutes = require("./routes/auth");
const jobRoutes = require("./routes/jobs");
const userRoutes = require("./routes/users");

// ==================== HEALTH CHECK ROUTES ====================
app.get("/", (req, res) => {
  res.json({
    message: "EarnSure API Running (Firebase Functions)",
    version: "1.0.0",
    status: "healthy",
    timestamp: new Date().toISOString(),
    routes: {
      auth: "/api/auth",
      jobs: "/api/jobs",
      users: "/api/users",
      health: "/api/health",
    },
  });
});

app.get("/api/health", (req, res) => {
  res.status(200).json({
    success: true,
    message: "Server is healthy",
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
  });
});

// ==================== API ROUTES ====================
app.use("/api/auth", authRoutes);
app.use("/api/jobs", jobRoutes);
app.use("/api/users", userRoutes);

// ==================== 404 HANDLER ====================
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found",
    path: req.path,
  });
});

// ==================== ERROR HANDLER ====================
app.use((err, req, res) => {
  console.error("Error:", err);

  if (err.name === "ValidationError") {
    return res.status(400).json({
      success: false,
      message: "Validation Error",
      errors: Object.values(err.errors).map((e) => e.message),
    });
  }

  if (err.code === 11000) {
    return res.status(400).json({
      success: false,
      message: "Duplicate field value",
    });
  }

  if (err.name === "JsonWebTokenError") {
    return res.status(401).json({
      success: false,
      message: "Invalid token",
    });
  }

  if (err.name === "TokenExpiredError") {
    return res.status(401).json({
      success: false,
      message: "Token expired",
    });
  }

  res.status(err.status || 500).json({
    success: false,
    message: err.message || "Internal Server Error",
  });
});

// ==================== FIREBASE FUNCTION EXPORT ====================
exports.api = functions.region("us-central1").https.onRequest(app);
