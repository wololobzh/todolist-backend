import express from "express";
import cors from "cors";
import todosRouter from "./routes/todos.js";

const app = express();
app.use(cors());
app.use(express.json());

app.use("/api/todos", todosRouter);

const PORT = 4000;
app.listen(PORT, () => console.log(`✅ Backend running on port ${PORT}`));
