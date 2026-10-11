require("dotenv").config();

const express = require("express");
const cors = require("cors");
const { rateLimit } = require("express-rate-limit");
const {
  initializeApp,
  applicationDefault,
} = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");

if (!process.env.GEMINI_API_KEY) {
  throw new Error("Missing GEMINI_API_KEY in .env");
}

initializeApp({
  credential: applicationDefault(),
});

const app = express();

// For local hackathon testing.
// Firebase token verification still protects the endpoint.
app.use(cors());
app.use(express.json({ limit: "16kb" }));

app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

// Reject requests without a valid Firebase login.
app.use("/chat", async (req, res, next) => {
  const header = req.get("Authorization") || "";

  if (!header.startsWith("Bearer ")) {
    return res.status(401).json({
      error: "Please log in to GoalDen first.",
    });
  }

  try {
    req.user = await getAuth().verifyIdToken(header.slice(7));
    next();
  } catch {
    res.status(401).json({
      error: "Your login expired. Please log in again.",
    });
  }
});

// Per-user demo limit; this resets when the server restarts.
app.use("/chat", rateLimit({
  windowMs: 60_000,
  limit: 5,
  keyGenerator: (req) => req.user.uid,
  message: { error: "Please wait a minute before sending more messages." },
}));

app.post("/chat", async (req, res) => {
  const message = req.body?.message;

  if (
    typeof message !== "string" ||
    !message.trim() ||
    message.length > 1500
  ) {
    return res.status(400).json({
      error: "Enter a message between 1 and 1500 characters.",
    });
  }

  const model = (
    process.env.GEMINI_MODEL || "gemini-3.5-flash-lite"
  ).trim();

  console.log("Using Gemini model:", model);

  try {
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(model)}:generateContent`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": process.env.GEMINI_API_KEY,
        },
        signal: AbortSignal.timeout(25_000),
        body: JSON.stringify({
systemInstruction: {
  parts: [{
    text: [
      "Generate one accurate financial-literacy fact for beginners.",
      "Use plain language and no more than 30 words.",
      "Include one practical budgeting or saving tip.",
      "Avoid current statistics, tax rules, specific financial products,",
      "investment recommendations, and unsupported claims.",
      "Return plain text without a heading.",
    ].join(" "),
  }],
},
      contents: [{
        role: "user",
        parts: [{
          text: `Give me a fact related to the term ${
            [
              "Assets",
              "Bonds",
              "Budgeting",
              "Compound interest",
              "Capital",
              "Credit",
              "Debit",
              "Equity",
              "Funds",
              "Grants",
              "High Yield Savings",
              "Index Fund",
              "Joint Stock",
              "401K ",
              "Loans",
              "Market",
              "Net-Asset Value (NAV)",
              "Online Banking",
              "Penny Stock",
              "Quant Fund",
              "Roth IRA",
              "ROI",
              "Stock",
              "Trade",
              "Unearned Income",
              "Value",
              "Wall Street",
              "Wealth",
              "XIRR",
              "Yield",
              "Zero Coupon Bond"

            ][Math.floor(Math.random() * 30)]
          }. Variation seed: ${Math.random()}`,
        }],
      }],
          generationConfig: {
            maxOutputTokens: 350,
            temperature: 0.5,
          },
        }),
      }
    );

    const data = await response.json();

    if (!response.ok) {
      // Log only the status, not keys or financial messages.
      console.error("Gemini request failed:", response.status);

      return res.status(response.status === 429 ? 429 : 502).json({
        error: response.status === 429
          ? "Gemini's free quota is busy or exhausted. Try again later."
          : "Gemini is unavailable. Check the server key and model settings.",
      });
    }

    const reply = (data.candidates?.[0]?.content?.parts || [])
      .filter((part) => !part.thought && typeof part.text === "string")
      .map((part) => part.text)
      .join("\n")
      .trim();

    res.json({
      reply: reply || "I could not answer that. Try rephrasing your question.",
    });
  } catch (error) {
  console.error("Gemini connection failed:", {
    name: error.name,
    message: error.message,
    cause: error.cause?.code,
  });

  res.status(502).json({
    error: "The AI request timed out or could not connect. Try again.",
  });
}
});

const port = Number(process.env.PORT || 3000);
app.listen(port, "0.0.0.0", () => {
  console.log(`GoalDen assistant running on port ${port}`);
});