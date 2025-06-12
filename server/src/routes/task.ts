import { Router } from "express";
import { auth, type AuthRequest } from "../middleware/auth";
import { tasks, type NewTask } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

const taskRouter = Router();

//the reason we have add auth here is we need to confirm
// theat use is authenticated before creating the task (middleware)
//route to create task
// taskRouter.post("/create", auth, async (req: AuthRequest, res) => {
//   try {
//     //create a new task in db

//     //before request new task
//     //need to update the body with user id
//     req.body = { ...req.body, dueAt: new Date(req.body.dueAt), uId: req.user };

//     const newTask: NewTask = req.body;

//     //insert the new task in db and retune it
//     const [task] = await db.insert(tasks).values(newTask).returning();

//     res.status(201).json(task);
//   } catch (error) {
//     console.log(error);
//     res.status(500).json({ error: error });
//   }
// });

taskRouter.post("/create", auth, async (req: AuthRequest, res) => {
  try {
    //destructure to get the uId and DueAt
    const { dueAt, ...rest } = req.body;

    const parsedDueAt = new Date(dueAt);
    //Attempts to convert the dueAt string (ISO format from Dart) into a real Date object.

    if (isNaN(parsedDueAt.getTime())) {
      res.status(400).json({ error: "Invalid dueAt date format" });
      return;
    }

    const newTask: NewTask = {
      ...rest,
      dueAt: parsedDueAt,
      uId: req.user,
    };

    const [task] = await db.insert(tasks).values(newTask).returning();

    res.status(201).json(task);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
});

//route to get the user's task
taskRouter.get("/fetch", auth, async (req: AuthRequest, res) => {
  try {
    //fetch the task in db and retune it
    const allTask = await db
      .select()
      .from(tasks)
      .where(eq(tasks.uId, req.user!));

    res.json(allTask);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error });
  }
});

//delete task
taskRouter.delete("/delete", auth, async (req: AuthRequest, res) => {
  try {
    //fetch the task in db and retune it
    const { taskId }: { taskId: string } = req.body;

    await db.delete(tasks).where(eq(tasks.id, taskId));

    res.json(true);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error });
  }
});

export default taskRouter;

/**This line uses array destructuring, which means you're extracting only the first item from the array returned by the query. So:

const [allTask] means: "Give me just the first task from the array of results."
As a result, res.json(allTask) sends only one task (the first one) as the response.

**/
