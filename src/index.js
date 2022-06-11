const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/error", (req, res) => {
  res
    .status(400)
    .send({ error: "test error", errorMessage: "test error message" });
});

app.get("/health", (req, res) => {
  res.status(200).send({ status: "healthy" });
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});