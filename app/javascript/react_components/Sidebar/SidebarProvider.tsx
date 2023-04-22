import React, {
  useState, useEffect, ReactNode, useMemo, useContext,
} from 'react';
import {
  HomeIcon, MagnifyingGlassCircleIcon, CalendarIcon, MegaphoneIcon, MapIcon, UserIcon, UsersIcon,
} from '@heroicons/react/24/outline';
import { useQuery } from '@tanstack/react-query';
import SidebarContext from './Context';
import axios from '../system/Axios';
import LanguageContext from '../Language/LanguageContext';
import { AuthInterface } from '../system/TypeScript';
import useAuth from '../Auth/useAuth';
// import AuthContext from '../Auth/AuthContext';

export default function SidebarProvider({ children }: { children: ReactNode }) {
  // const [example, setExample] = useState([]);
  // const { user } = useContext<AuthInterface>(AuthContext);

  const { user } = useAuth();

  const {
    isLoading, error, data, isFetching,
  } = useQuery(
    ['sidebar', user?.id],
    () => axios
      .get('/api/listings/sidebar')
      .then((res) => res.data)
      .then((data) => {
        const result = [];
        const chunks = new URL(window.location.href).pathname.split('/');
        const listingId = chunks.pop();

        data.forEach((item) => {
          result.push({
            id: item.id,
            name: item.name,
            icon: (item.is_public ? UsersIcon : UserIcon),
            current: listingId === item.id.toString(),
            is_public: item.is_public,
          });
        });
        return result;
      }),
  );

  const [sidebarOpen, setSidebarOpen] = React.useState(false);

  const value = useMemo(() => ({
    navigation: data || [],
    sidebarOpen,
    setSidebarOpen,
  }), [data, sidebarOpen, setSidebarOpen]);

  // const [user, setUser] = useState<User>();
  // const value = useMemo(() => ({ user, setUser }), [user, setUser]);

  return (
    <SidebarContext.Provider value={value}>
      {children}
    </SidebarContext.Provider>
  );
}
