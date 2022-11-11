import React, {
  useState, useEffect, ReactNode, useMemo,
} from 'react';
import resolveConfig from 'tailwindcss/resolveConfig';
import { User } from '../system/TypeScript';
import tailwindConfig from '../../../../tailwind.config.js';
import TailwindConfigContext from './TailwindConfigContext';

export default function TailwindConfigProvider({ children }: {children: ReactNode}) {
  // const fullConfig = resolveConfig(tailwindConfig);
  const fullConfig = {fullConfig: {}};

  return (
    <TailwindConfigContext.Provider value={fullConfig}>
      {children}
    </TailwindConfigContext.Provider>
  );
}
