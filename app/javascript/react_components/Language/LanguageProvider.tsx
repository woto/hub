import React, {
  useState, useEffect, ReactNode, useMemo,
} from 'react';
import { User } from '../system/TypeScript';
import LanguageContext from './LanguageContext';
import Auth from './useAuth';

export default function LanguageProvider({ children }: {children: ReactNode}) {
  const [language, setLanguage] = useState<{ code: string; path: string; }>({ code: null, path: '' });

  useEffect(() => {
    const chunks = new URL(window.location.href).pathname.split('/');
    const lang = chunks[1];
    if (['en', 'en-US', 'ru'].includes(lang)) {
      setLanguage({
        code: lang,
        path: `/${lang}`,
      });
    } else {
      // setLanguage({
      //   code: null,
      //   path: '',
      // });
    }
  }, []);

  return (
    <LanguageContext.Provider value={language}>
      {children}
    </LanguageContext.Provider>
  );
}
