import * as React from 'react';
import { createContext } from 'react';
import { TailwindConfigInterface } from '../system/TypeScript';

const TailwindConfigContext = createContext<TailwindConfigInterface>({} as TailwindConfigInterface);
export default TailwindConfigContext;
