import React, {
  useState, useEffect, useContext, useCallback,
} from 'react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import axios from '../system/Axios';
import { AuthInterface } from '../system/TypeScript';
import AuthContext from './AuthContext';
import { AxiosError } from 'axios';

export default function useAuth() {
  // const { user, refetchUser } = useContext<AuthInterface>(AuthContext);
  const queryClient = useQueryClient();

  const {
    isLoading, error, data, isFetching,
  } = useQuery({
    queryKey: ['profile'],
    queryFn: () => axios
      .get('/api/user/me')
      .then((res) => {
        console.log('refetched');
        return res.data;
      }),
    retry: (_: any, err: AxiosError) => {
      if (err.response.status === 401) return false;
      return true;
    },
  });

  const refetchUser = useCallback(() => {
    console.log('refetching user');
    queryClient.refetchQueries({ queryKey: ['profile'] });
    // queryClient.removeQueries({ queryKey: ['profile'] });
  }, [queryClient]);

  React.useEffect(() => {
    // const { data: user } = getProfile();

    const handleSuccessResponse = (e) => {
      console.log('message', e.data);
      if (e.data === 'auth-succeeded') {
        refetchUser();
        e.source.close();
      }
    };
    window.addEventListener('message', handleSuccessResponse, false);

    return () => {
      window.removeEventListener('message', handleSuccessResponse);
    };
  }, [refetchUser]);

  // const signout = () => firebase
  //   .auth()
  //   .signOut()
  //   .then(() => handleUser(false));

  // useEffect(() => {
  //   const unsubscribe = firebase.auth().onAuthStateChanged(handleUser);

  //   return () => unsubscribe();
  // }, []);

  return {
    user: data,
    refetchUser,
    // loading,
    // signinWithGitHub,
    // signout,
  };
}
