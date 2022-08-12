import React, {MouseEventHandler} from "react";
import {ToastContextInterface, ToastType} from "../main";

const Ctx = React.createContext<ToastContextInterface>({add: null, remove: null});

// Styled Components
// ==============================

const ToastContainer = (props: { children: React.ReactNode }) => (
  <div style={{position: "fixed", right: 0, top: 0}} {...props} />
);

const TmpToast = (props: { children: React.ReactNode, onDismiss: MouseEventHandler<HTMLDivElement> | undefined }) => (
  <div
    style={{
      background: "LemonChiffon",
      cursor: "pointer",
      fontSize: 14,
      margin: 10,
      padding: 10
    }}
    onClick={props.onDismiss}
  >
    {/*<Toast></Toast>*/}
    {props.children}
  </div>
);

// Provider
// ==============================

let toastCount = 0;

export function ToastProvider(props: { children: React.ReactNode }) {
  const [toasts, setToasts] = React.useState<ToastType[]>([]);

  const add = (content: string) => {
    const id = toastCount++;
    const toast = {content, id};
    setToasts((prevToasts) => [...prevToasts, toast]);
  };

  const remove = (id: number) => {
    const newToasts = toasts.filter((t: ToastType) => t.id !== id);
    setToasts(newToasts);
  };

  // avoid creating a new fn on every render
  const onDismiss = (id: number) => () => remove(id);

  return (
    <Ctx.Provider value={{add, remove}}>
      {props.children}
      <ToastContainer>
        {toasts.map(({content, id, ...rest}) => (
          <TmpToast key={id} onDismiss={onDismiss(id)} {...rest}>
            {id + 1} &mdash; {content}
          </TmpToast>
        ))}
      </ToastContainer>
    </Ctx.Provider>
  );
}

// Consumer
// ==============================

export const useToasts = () => React.useContext(Ctx);
