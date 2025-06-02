import { Router, type Request, type Response } from "express";
import { db } from "../db";
import { users, type NewUser } from "../db/schema";
import { eq } from "drizzle-orm";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";

const authRouter = Router();

interface registerUserBody {
  name: string;
  email: string;
  password: string;
  confirmPassword: string;
}

interface loginUserBody {
  email: string;
  password: string;
}

//resgister user
authRouter.post(
  "/register",
  // eslint-disable-next-line @typescript-eslint/no-empty-object-type
  async (req: Request<{}, {}, registerUserBody>, res: Response) => {
    try {
      //get the request body
      const { name, email, password, confirmPassword } = req.body;

      //check if the user is already exists
      //first from db colum then second one from the body email
      const existingUser = await db
        .select()
        .from(users)
        .where(eq(users.email, email));

      if (existingUser.length > 0) {
        res.status(400).json({ error: "User already exists with this email" });
        return;
      }
      //hashed the password
      if (password !== confirmPassword) {
        res
          .status(400)
          .json({ error: "Password and confirm password does not match" });
        return;
      }
      const hashedPassword = await bcrypt.hash(confirmPassword, 10);

      //create a new user then store it in db

      const newUser: NewUser = {
        name,
        email,
        password: hashedPassword,
      };

      const [user] = await db.insert(users).values(newUser).returning();

      //200 is okay
      //201 is created
      res.status(201).json(user);
    } catch (error) {
      res.status(500).json({ error: error });
    }
  }
);

//login user
authRouter.post(
  "/login",
  // eslint-disable-next-line @typescript-eslint/no-empty-object-type
  async (req: Request<{}, {}, loginUserBody>, res: Response) => {
    try {
      //get the request body
      const { email, password } = req.body;

      //check if the user is already exists
      //first from db colum then second one from the body email
      const [existingUser] = await db
        .select()
        .from(users)
        .where(eq(users.email, email));

      if (!existingUser) {
        res.status(400).json({ error: "User does not exists with this email" });
        return;
      }

      //hashed the password

      const isMatch = await bcrypt.compare(password, existingUser.password);

      if (!isMatch) {
        res.status(400).json({ error: "Password is incorrect" });
        return;
      }

      //creatign a token with jwt
      const token = jwt.sign(
        { id: existingUser.id },
        process.env.JWT_SECRET as string
      );

      //200 is okay
      //201 is created
      res.json({ token, ...existingUser });
    } catch (error) {
      res.status(500).json({ error: error });
    }
  }
);

//to check if the user is authenticated
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    //get the header to get the token
    const token = req.header("x-auth-token");

    if (!token) {
      res.json(false);
      return;
    }
    //if the token is not sent we return false

    const verfied = jwt.verify(token, process.env.JWT_SECRET as string);

    if (!verfied) {
      res.json(false);
      return;
    }
    //then to verfy the token is valid or not
    //extrat the id then stored in verfiedToke
    const verfiedToke = verfied as { id: string };

    //fetch the user from db to match the id in the token
    //id = primary key

    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, verfiedToke.id));

    if (!user) {
      res.json(false);
      return;
    }

    //sending bool value
    res.json(true);
    //if no user we return false
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
  } catch (e) {
    res.status(500).json(false);
  }
});

authRouter.get("/", (req, res) => {
  res.send("Hey there, this is from auth router");
});

export default authRouter;
