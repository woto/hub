import axios from '../system/Axios';
import React, {
  useState, useEffect, useContext,
} from 'react';
import { AuthInterface } from '../system/TypeScript';
import AuthContext from './AuthContext';

export default function useAuth() {
  const { user, setUser } = useContext<AuthInterface>(AuthContext);

  React.useEffect(() => {
    const handleSuccessResponse = (e) => {
      if (e.data === 'auth-succeeded') {
        axios.get('/api/me').then((response) => {
          setUser(response.data);
        });
        e.source.close();
      }
    };

    // ['turbo:load'].forEach((eventName) => {
    ['DOMContentLoaded'].forEach((eventName) => {
      window.addEventListener('message', handleSuccessResponse, false);
    });
  }, []);

  // const signout = () => firebase
  //   .auth()
  //   .signOut()
  //   .then(() => handleUser(false));

  // useEffect(() => {
  //   const unsubscribe = firebase.auth().onAuthStateChanged(handleUser);

  //   return () => unsubscribe();
  // }, []);

  return {
    user,
    setUser,
    // loading,
    // signinWithGitHub,
    // signout,
  };
}
