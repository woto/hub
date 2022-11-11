import * as React from "react";
import { createContext } from "react";
import { LanguageInterface } from "./system/TypeScript";

const LanguageContext = createContext<LanguageInterface>({} as LanguageInterface);
export default LanguageContext;
