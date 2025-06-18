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

//update the db with unsynced tasks
taskRouter.post("/sync", auth, async (req: AuthRequest, res) => {
  try {
    //get the unsynced tasks from the request body

    const tasksList = req.body;

    const filteredTasks: NewTask[] = [];

    for (let task of tasksList) {
      // date = new date object
      task = {
        ...task,
        dueAt: new Date(task.dueAt),
        createdAt: new Date(task.createdAt),
        updatedAt: new Date(task.updatedAt),
        uId: req.user,
      };

      filteredTasks.push(task);
    }

    const pushTask = await db.insert(tasks).values(filteredTasks).returning();

    console.log("Received tasks for sync:", tasksList);

    res.status(201).json(pushTask);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
});

export default taskRouter;

/**This line uses array destructuring, which means you're extracting only the first item from the array returned by the query. So:

const [allTask] means: "Give me just the first task from the array of results."
As a result, res.json(allTask) sends only one task (the first one) as the response.

**/

//this is a string from the flutter app this value cannot be used directly in the db
// Received tasks for sync: [ "{\"id\":\"1f04ae86-f96d-6770-b9dc-e99c60b656f5\",\"uId\":\"06b08d23-4f81-4772-a03c-1bff353fb721\",\"title\":\"Testing this in offline\",\"description\":\"Testing this in offline\",\"hexColor\":\"#18ffff\",\"dueAt\":\"2025-06-17T01:00:24.514294\",\"createdAt\":\"2025-06-17T01:01:01.377976\",\"updatedAt\":\"2025-06-17T01:01:01.378010\",\"isSynced\":0}",
// mytask_backend      |   "{\"id\":\"1f04baca-0f0a-6930-975d-ddf7b83b6c4a\",\"uId\":\"06b08d23-4f81-4772-a03c-1bff353fb721\",\"title\":\"Tesing this offline\",\"description\":\"Tesing this offline\",\"hexColor\":\"#b388ff\",\"dueAt\":\"2025-06-18T00:24:58.767546\",\"createdAt\":\"2025-06-18T00:25:25.535431\",\"updatedAt\":\"2025-06-18T00:25:25.535466\",\"isSynced\":0}"
// mytask_backend      | ]
