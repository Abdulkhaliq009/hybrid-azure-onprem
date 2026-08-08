require("dotenv").config();

const appInsights = require("applicationinsights");
if (process.env.APPLICATIONINSIGHTS_CONNECTION_STRING) {
  appInsights.setup(process.env.APPLICATIONINSIGHTS_CONNECTION_STRING)
    .setAutoDependencyCorrelation(true)
    .setAutoCollectRequests(true)
    .setAutoCollectPerformance(true)
    .setAutoCollectExceptions(true)
    .setAutoCollectDependencies(true)
    .start();
}

const express = require("express");
const sql = require("mssql");

const app = express();
const PORT = process.env.PORT || 3000;

const dbConfig = {
  server: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || "1433"),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    region: process.env.WEBSITE_SITE_NAME || "local",
  });
});

app.get("/products", async (req, res) => {
  try {
    await sql.connect(dbConfig);
    const result = await sql.query("SELECT * FROM products ORDER BY id");
    res.json({
      source: "on-prem SQL Server",
      host: process.env.DB_HOST,
      count: result.recordset.length,
      data: result.recordset,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`API running on port ${PORT}`);
  console.log(`DB host: ${process.env.DB_HOST}`);
  console.log(`App Insights: ${process.env.APPLICATIONINSIGHTS_CONNECTION_STRING ? "enabled" : "disabled"}`);
});
