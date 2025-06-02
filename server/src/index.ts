import express from "express";
import authRouter from "./routes/auth";

const app = express();

//take a look at the all the incoming request then only pass the json relaoted routes as middleware
app.use(express.json());

//buinding the auth route to index as middleware
app.use("/auth", authRouter);

app.get("/", (req, res) => {
  res.send(
    "Hello World! and this has been updated and this is from hot reload..."
  );
});

app.listen(8000, () => {
  console.log("🔁 Server started at", new Date().toLocaleTimeString());
});
