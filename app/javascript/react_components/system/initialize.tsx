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

import { createRoot } from 'react-dom/client';
import * as React from 'react';
import {
  QueryClient,
  QueryClientProvider,
} from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import {
  createBrowserRouter,
  RouterProvider,
} from 'react-router-dom';
import Root from './Root';

import { ToastProvider } from '../Toast/ToastManager';

let root;

// ['turbo:load'].forEach((event) => {
['DOMContentLoaded'].forEach((event) => {
  const id = 'root';

  document.addEventListener(event, () => {
    let container = document.querySelector(`#${id}`);

    if (!container) {
      container = document.createElement('div');
      container.setAttribute('id', id);
      document.body.appendChild(container);
    }

    root = createRoot(container!);
  });
});

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
    },
  },
});

const router = createBrowserRouter([
  {
    path: '*',
    element: <Root />,
  },
]);

const render = () => {
  root.render(
    <React.StrictMode>
      <QueryClientProvider client={queryClient}>
        <ToastProvider>
          <RouterProvider router={router} />
          { process.env.REACT_QUERY_DEVTOOLS === 'true' && <ReactQueryDevtools initialIsOpen /> }
        </ToastProvider>
      </QueryClientProvider>
    </React.StrictMode>,
  );
};

['DOMContentLoaded'].forEach((eventName) => {
// ['turbo:load', 'turbo:frame-load'].forEach((eventName) => {
  document.addEventListener(eventName, (event) => {
    render();
  });
});

// ['turbo:before-stream-render'].map((eventName) => {
//   document.addEventListener(eventName, async (event) => {
//     event.preventDefault();
//     event.target.performAction();
//     render();
//   });
// });
