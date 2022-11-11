import * as React from 'react';
import { useEffect } from 'react';
import useAuth from './Auth/useAuth';
import { User } from './system/TypeScript';

export default function Example5(props: User) {
  const auth = useAuth();

  useEffect(() => {
    auth.setUser(props);
  }, []);

  return (null);
}
