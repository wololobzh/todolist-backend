import express from "express";
const router = express.Router();

let todos = [];

router.get("/", (req, res) => res.json(todos));

router.post("/", (req, res) => {
  const text = String(req.body?.text || "").trim();
  if (!text) return res.status(400).json({ error: "text is required" });
  const todo = { id: Date.now(), text, done: false };
  todos.push(todo);
  res.status(201).json(todo);
});

router.put("/:id", (req, res) => {
  const id = Number(req.params.id);
  todos = todos.map((t) => (t.id === id ? { ...t, done: !t.done } : t));
  res.json(todos);
});

router.delete("/:id", (req, res) => {
  const id = Number(req.params.id);
  todos = todos.filter((t) => t.id !== id);
  res.status(204).send();
});

export default router;
