import * as React from 'react';
import { createContext } from 'react';
import { AuthInterface } from '../system/TypeScript';

const AuthContext = createContext<AuthInterface>({} as AuthInterface);
export default AuthContext;
