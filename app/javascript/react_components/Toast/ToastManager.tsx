import React, { MouseEventHandler, ReactNode } from 'react';
import { motion } from 'framer-motion';
import { ToastContextInterface, ToastType } from '../main';
import Toast from './Toast';

const Ctx = React.createContext({} as ToastContextInterface);

// Styled Components
// ==============================

function ToastContainer(props: { children: React.ReactNode }) {
  return (
    <div
      aria-live="assertive"
      className="tw-fixed tw-z-20 tw-inset-0 tw-flex tw-items-end tw-px-4 tw-py-6 tw-pointer-events-none sm:tw-p-6 sm:tw-items-start"
    >
      <div className="tw-w-full tw-flex tw-flex-col tw-items-center tw-space-y-4 sm:tw-items-end">
        {props.children}
      </div>
    </div>
  );
}

// const TmpToast = (props: { children: React.ReactNode, onDismiss: MouseEventHandler<HTMLDivElement> | undefined }) => (
//   <div
//     style={{
//       background: "LemonChiffon",
//       cursor: "pointer",
//       fontSize: 14,
//       margin: 10,
//       padding: 10,
//       display: 'flex'
//     }}
//     onClick={props.onDismiss}
//   >
//     <Toast></Toast>
//     {props.children}
//   </div>
// );

// Provider
// ==============================

let toastCount = 0;

export function ToastProvider(props: { children: React.ReactNode }) {
  const [toasts, setToasts] = React.useState<ToastType[]>([]);

  const add = (content: string | ReactNode) => {
    const id = toastCount++;
    const toast = { content, id };
    setToasts((prevToasts) => [...prevToasts, toast]);
  };

  const remove = (id: number) => {
    const newToasts = toasts.filter((t: ToastType) => t.id !== id);
    setToasts(newToasts);
  };

  // avoid creating a new fn on every render
  const onDismiss = (id: number) => () => remove(id);

  return (
    <Ctx.Provider value={{ add, remove }}>
      {props.children}
      <ToastContainer>
        {toasts.map(({ content, id, ...rest }) => (
          <Toast key={id} onDismiss={onDismiss(id)} {...rest}>
            <div className="tw-ml-3 tw-font-medium tw-flex-1 tw-pt-0.5 tw-text-sm tw-text-gray-900">
              {content}
            </div>
          </Toast>
        ))}
      </ToastContainer>
    </Ctx.Provider>
  );
}

// Consumer
// ==============================

export const useToasts = () => React.useContext(Ctx);
