import React, {
  useState, useEffect, ReactNode, useMemo,
} from 'react';
import { User } from '../system/TypeScript';
import AuthContext from './AuthContext';
import Auth from './useAuth';

export default function AuthProvider({ children }: {children: ReactNode}) {
  const [user, setUser] = useState<User>();
  const value = useMemo(() => ({ user, setUser }), [user, setUser]);

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}
