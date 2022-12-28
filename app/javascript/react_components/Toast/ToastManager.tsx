import React, {
  MouseEventHandler, ReactNode, useCallback, useMemo,
} from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { ToastContextInterface, ToastType } from '../main';
import Toast from './Toast';

const Ctx = React.createContext({} as ToastContextInterface);

function ToastContainer(props: { children: React.ReactNode }) {
  return (
    <div
      aria-live="assertive"
      className="tw-fixed tw-inset-0 tw-flex tw-items-end tw-px-4 tw-py-6 tw-pointer-events-none sm:tw-p-6 sm:tw-items-start"
    >
      <div className="tw-w-full tw-flex tw-flex-col tw-items-center tw-space-y-4 sm:tw-items-end">
        {props.children}
      </div>
    </div>
  );
}

let toastCount = 0;

export function ToastProvider(props: { children: React.ReactNode }) {
  const [toasts, setToasts] = React.useState<ToastType[]>([]);

  const add = useCallback((content: string | ReactNode) => {
    toastCount += 1;
    const id = toastCount;
    const toast = { content, id };
    setToasts((prevToasts) => [...prevToasts, toast]);
  }, []);

  const remove = useCallback((id: number) => {
    const newToasts = toasts.filter((t: ToastType) => t.id !== id);
    setToasts(newToasts);
  }, [toasts]);

  const value = useMemo(() => ({ add, remove }), [add, remove]);

  return (
    <Ctx.Provider value={value}>
      {props.children}
      <ToastContainer>
        <AnimatePresence>
          {toasts.map(({ content, id }) => (
            <Toast key={id} id={id} remove={remove}>
              <div className="tw-ml-3 tw-font-medium tw-flex-1 tw-pt-0.5 tw-text-sm tw-text-gray-900">
                {content}
              </div>
            </Toast>
          ))}
        </AnimatePresence>
      </ToastContainer>
    </Ctx.Provider>
  );
}

// Consumer
// ==============================

export const useToasts = () => React.useContext(Ctx);
