import type { UUID } from "crypto";
import type { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { users } from "../db/schema";
import { eq } from "drizzle-orm";
import { db } from "../db";

export interface AuthRequest extends Request {
  user?: UUID;
  token?: string;
}
export const auth = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    //get the header to get the token
    const token = req.header("x-auth-token");

    if (!token) {
      //401 means unathorized
      res.status(401).json({ error: "No auth token, authorization denied" });
      return;
    }
    //if the token is not sent we return false

    const verfied = jwt.verify(token, process.env.JWT_SECRET as string);

    if (!verfied) {
      res.status(401).json({ error: "Token verification failed" });
      return;
    }
    //then to verfy the token is valid or not
    //extrat the id then stored in verfiedToke
    const verfiedToke = verfied as { id: UUID };

    //fetch the user from db to match the id in the token
    //id = primary key

    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, verfiedToke.id));

    if (!user) {
      res.status(401).json({ error: "User not found" });
      return;
    }

    req.user = verfiedToke.id;
    req.token = token;

    next();
    //if no user we return false
  } catch (e) {
    res.status(500).json({ error: e });
  }
};
