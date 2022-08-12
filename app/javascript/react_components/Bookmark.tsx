import {useState} from 'react'
import * as React from 'react';
import { usePopper } from 'react-popper';
import {Popover, Transition} from '@headlessui/react'
import {FireIcon, PlusIcon, SortAscendingIcon, StarIcon} from "@heroicons/react/solid";
// import {autoPlacement, FloatingPortal} from '@floating-ui/react-dom-interactions';

// import {
//   autoUpdate, useFloating, offset,
//   flip,
//   shift
// } from '@floating-ui/react-dom';

import {
  // useQuery,
  // useMutation,
  useQueryClient,
  QueryClient,
  QueryClientProvider, useMutation,
} from 'react-query'
import axios from "axios";

import {useToasts} from "./system/ToastManager";

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

const people = [
  {
    name: 'Leonard Krasner1',
    handle: 'leonardkrasner1',
    imageUrl:
      'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
  },
  {
    name: 'Leonard Krasner2',
    handle: 'leonardkrasner2',
    imageUrl:
      'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
  },
  {
    name: 'Leonard Krasner3',
    handle: 'leonardkrasner3',
    imageUrl:
      'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
  },
  {
    name: 'Leonard Krasner4',
    handle: 'leonardkrasner4',
    imageUrl:
      'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
  },
  {
    name: 'Floyd Miles',
    handle: 'floydmiles',
    imageUrl:
      'https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
  },
  {
    name: 'Emily Selman',
    handle: 'emilyselman',
    imageUrl:
      'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
  },
  {
    name: 'Kristin Watson',
    handle: 'kristinwatson',
    imageUrl:
      'https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
  },
]

function List() {
  return (
    <div className="tw-max-h-60 tw-overflow-y-auto">
      <div className="tw-flow-root">
        <ul role="list" className="-tw-my-5 tw-divide-y tw-divide-gray-200">
          {people.map((person) => (
            <li key={person.handle} className="tw-py-4">
              <div className="tw-flex tw-items-center tw-space-x-4">
                <div className="tw-flex-shrink-0">
                  <img className="tw-h-8 tw-w-8 tw-rounded-full" src={person.imageUrl} alt=""/>
                </div>
                <div className="tw-flex-1 tw-min-w-0">
                  <p className="tw-text-sm tw-font-medium tw-text-gray-900 tw-truncate">{person.name}</p>
                  <p className="tw-text-sm tw-text-gray-500 tw-truncate">{'@' + person.handle}</p>
                </div>
                <div>
                  <a
                    href="#"
                    className="tw-inline-flex tw-items-center tw-shadow-sm tw-px-2.5 tw-py-0.5 tw-border tw-border-gray-300 tw-text-sm tw-leading-5 tw-font-medium tw-rounded-full tw-text-gray-700 tw-bg-white hover:tw-bg-gray-50"
                  >
                    View
                  </a>
                </div>
              </div>
            </li>
          ))}
        </ul>
      </div>

      {false &&
        <a
          href="#"
          className="tw-w-full tw-flex tw-justify-center tw-items-center tw-px-4 tw-py-2 tw-border tw-border-gray-300 tw-shadow-sm tw-text-sm tw-font-medium tw-rounded-md tw-text-gray-700 tw-bg-white hover:tw-bg-gray-50"
        >
          View all
        </a>
      }
    </div>
  )
}

function Form(props: { extId: string, favoritesItemsKind: string }) {
  const [title, setTitle] = useState('');
  const {add} = useToasts();

  const mutation = useMutation<unknown, unknown, { ext_id: string, favorites_items_kind: string, name: string, is_checked: boolean }>(newTodo => {
    add('test');
    const csrfToken = document.querySelector("[name='csrf-token']").getAttribute('content');
    return axios.post('/favorites', newTodo,
      {
        headers: {
          'X-CSRF-TOKEN': csrfToken,
          "Content-Type": "application/json",
          Accept: "application/json"
        }
      }
    )
  })

  return (
    <>
      <div className="tw-mt-1 tw-flex tw-rounded-md tw-shadow-sm">
        <div className="tw-relative tw-flex tw-items-stretch tw-flex-grow focus-within:tw-z-10">
          <input
            type="text"
            name="title"
            className="focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block tw-w-full tw-rounded-none tw-rounded-l-md sm:tw-text-sm tw-border-gray-300"
            placeholder="Укажите название"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
          />
        </div>
        <button
          onClick={() => {
            mutation.mutate({ ext_id: props.extId, favorites_items_kind: props.favoritesItemsKind, name: title, is_checked: true })
          }}
          type="button"
          className="-tw-ml-px tw-relative tw-inline-flex tw-items-center tw-space-x-2 tw-px-4 tw-py-2 tw-border tw-border-gray-300 tw-text-sm tw-font-medium tw-rounded-r-md tw-text-gray-700 tw-bg-gray-50 hover:tw-bg-gray-100 focus:tw-outline-none focus:tw-ring-1 focus:tw-ring-indigo-500 focus:tw-border-indigo-500"
        >
          <PlusIcon className="tw-h-5 tw-w-5 tw-text-gray-400" aria-hidden="true"/>
        </button>
      </div>
    </>
  )
}

export default function Bookmark(props: { ext_id: string, favorites_items_kind: string, is_checked: boolean }) {

  const popperElRef = React.useRef(null);
  const [targetElement, setTargetElement] = React.useState(null);
  const [popperElement, setPopperElement] = React.useState(null);
  const { styles, attributes } = usePopper(targetElement, popperElement, {
    // strategy: 'fixed',
    placement: "bottom",
    modifiers: [
      {
        name: "offset",
        options: {
          offset: [0, 8]
        }
      }
    ]
  });

  const [items, setItems] = useState([])
  // const {x, y, reference, floating, strategy, update, refs} = useFloating({
  //   strategy: "fixed",
  //   middleware: [autoPlacement()],
  //   whileElementsMounted: autoUpdate
  // });

  // useEffect(() => {
  //   // debugger
  //   update()
  // }, [floating, update, refs.floating, refs.reference])

  // debugger
  // console.log(reference);
  // console.log(floating);
  // console.log(strategy);

  return (
    <Popover className="tw-relative">
      {({open}) => (
        <div ref={setTargetElement} className={`tw-relative ${open ? 'tw-z-30' : 'tw-z-20'}`}>
          <Popover.Button
            // ref={reference}
            className={classNames(
              open ? 'tw-z-50 tw-text-gray-900' : 'z-30 tw-text-gray-500',
              'tw-group tw-rounded tw-inline-flex tw-items-center tw-text-base tw-font-medium hover:tw-text-gray-700 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-gray-500'
            )}
          >
            <FireIcon
              className={
                classNames(open ? 'tw-text-gray-800' : 'tw-text-gray-500',
                  `${props.is_checked ? 'tw-bg-red-400' : ''} tw-h-6 tw-w-6 group-hover:tw-text-gray-600 tw-mr-1`)
              }
              aria-hidden="true"
            />
            Запомнить
          </Popover.Button>

          {/*<FloatingPortal>*/}
          <div
            ref={popperElRef}
            style={styles.popper}
            {...attributes.popper}
            >
            <Transition
              appear={true}
              show={open}
              // as={Fragment}
              enter="tw-transition tw-ease-out tw-duration-200"
              enterFrom="tw-opacity-0 tw-translate-y-1"
              enterTo="tw-opacity-100 tw-translate-y-0"
              leave="tw-transition tw-ease-in tw-duration-150"
              leaveFrom="tw-opacity-100 tw-translate-y-0"
              leaveTo="tw-opacity-0 tw-translate-y-1"
              beforeEnter={() => setPopperElement(popperElRef.current)}
              afterLeave={() => setPopperElement(null)}
            >
              <Popover.Panel
                // ref={floating}
                // style={{
                //   position: strategy,
                //   top: y ?? 0,
                //   left: x ?? 0
                // }}

                // className="tw-absolute tw-z-10 tw-left-1/2 tw-transform -tw-translate-x-1/2 tw-mt-3 tw-px-2 tw-w-screen tw-max-w-xs sm:tw-px-0"
                className="tw-z-40 tw-transform tw-mt-3 tw-px-2 tw-w-screen tw-max-w-xs sm:tw-px-0"
              >
                <div
                  className="tw-rounded-lg tw-shadow-lg tw-ring-1 tw-ring-black tw-ring-opacity-5 tw-overflow-hidden">
                  <div className="tw-relative tw-grid tw-gap-3 tw-bg-white tw-px-5 tw-py-6 sm:tw-gap-8 sm:tw-p-8">
                    <List></List>
                    <Form extId={props.ext_id} favoritesItemsKind={props.favorites_items_kind}></Form>
                  </div>
                </div>
              </Popover.Panel>
            </Transition>
          </div>
          {/*</FloatingPortal>*/}
        </div>
      )}
    </Popover>
  )
}