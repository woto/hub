// import * as React from "react"
// import ReactDOM from 'react-dom'
//
// import Root from './Root';
//
// ['turbo:load'].map((event) => {
//   const id = 'root';
//
//   document.addEventListener(event, () => {
//     let reactRoot = document.querySelector(`#${id}`);
//
//     if (!reactRoot) {
//       reactRoot = document.createElement('div');
//       reactRoot.setAttribute('id', id);
//       document.body.appendChild(reactRoot);
//     }
//
//     ReactDOM.render(
//       <React.StrictMode>
//         <Root></Root>
//       </React.StrictMode>,
//       reactRoot,
//     )
//   })
// })

import { createRoot } from 'react-dom/client'
import * as React from "react"
import Root from './Root';
import {
  useQuery,
  useMutation,
  useQueryClient,
  QueryClient,
  QueryClientProvider,
} from 'react-query'

import {ToastProvider} from "./ToastManager";

let root;

['turbo:load'].map((event) => {
  const id = 'root';

  document.addEventListener(event, () => {
    let container = document.querySelector(`#${id}`);

    if (!container) {
      container = document.createElement('div');
      container.setAttribute('id', id);
      document.body.appendChild(container);
    }

    root = createRoot(container!)
  })
});

const queryClient = new QueryClient()

const render = () => {
  root.render(
    <React.StrictMode>
      <QueryClientProvider client={queryClient}>
        <ToastProvider>
          <Root></Root>
        </ToastProvider>
      </QueryClientProvider>
    </React.StrictMode>
  )
}

['turbo:load', 'turbo:frame-load'].map((eventName) => {
  document.addEventListener(eventName, (event) => {
    render()
  })
});

['turbo:before-stream-render'].map((eventName) => {
  document.addEventListener(eventName, async (event) => {
    event.preventDefault();
    event.target.performAction();
    render();
  })
});