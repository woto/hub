import * as React from 'react';
import { useEffect } from 'react';
import useAuth from './useAuth';
import { User } from '../system/TypeScript';

export default function SetUser(props: User) {
  const auth = useAuth();

  useEffect(() => {
    auth.setUser(props);
  }, []);

  return (null);
}
