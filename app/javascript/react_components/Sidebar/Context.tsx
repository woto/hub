import * as React from "react";
import { createContext } from "react";
import { SidebarInterface } from "./system/TypeScript";

const SidebarContext = createContext<SidebarInterface>({} as SidebarInterface);
export default SidebarContext;
