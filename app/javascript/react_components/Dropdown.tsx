import * as React from "react";

/* This example requires Tailwind CSS v2.0+ */
import { Fragment } from 'react'
import { Popover, Transition } from '@headlessui/react'
import { ChevronDownIcon } from '@heroicons/react/solid'

// import DropdownCalendar from './Dropdown/Calendar';
// import Sentiment from './Dropdown/Sentiment';

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

export default function Dropdown(props: {title: string, width: number}) {
  return (
    <Popover className="tw-relative">
      {({ open }) => (
        <>
          <Popover.Button
            className={classNames(
              open ? 'tw-text-gray-900' : 'tw-text-gray-500',
              'tw-group tw-inline-flex tw-justify-center tw-text-sm tw-font-medium tw-text-gray-700 hover:tw-text-gray-900'
            )}
          >
            <span>{props.title}</span>
            <ChevronDownIcon
              className={classNames(open ? 'tw-text-gray-600' : 'tw-text-gray-400', 'tw-ml-2 tw-h-5 tw-w-5 group-hover:tw-text-gray-500')}
              aria-hidden="true"
            />
          </Popover.Button>

          <Transition
            as={Fragment}
            enter="tw-transition tw-ease-out tw-duration-200"
            enterFrom="tw-opacity-0 tw-translate-y-1"
            enterTo="tw-opacity-100 tw-translate-y-0"
            leave="tw-transition tw-ease-in tw-duration-150"
            leaveFrom="tw-opacity-100 tw-translate-y-0"
            leaveTo="tw-opacity-0 tw-translate-y-1"
          >
            <Popover.Panel className="tw-min-w-[700px] tw-origin-top-right tw-absolute tw-right-0 tw-mt-2 tw-bg-white tw-rounded-md tw-shadow-2xl tw-p-4 tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
              <div className="tw-py-1">
                {props.children}
              </div>
            </Popover.Panel>
          </Transition>
        </>
      )}
    </Popover>
  )
}


// function classNames(...classes) {
//   return classes.filter(Boolean).join(' ')
// }
//
// export default function TestDropdown() {
//   return (
//     <Menu as="div" className="tw-relative tw-inline-block tw-text-left">
//       <div>
//         <Menu.Button className="tw-inline-flex tw-justify-center tw-w-full tw-rounded-md tw-border tw-border-gray-300 tw-shadow-sm tw-px-4 tw-py-2 tw-bg-white tw-text-sm tw-font-medium tw-text-gray-700 hover:tw-bg-gray-50 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-offset-gray-100 focus:tw-ring-indigo-500">
//           Options
//           <ChevronDownIcon className="-tw-mr-1 tw-ml-2 tw-h-5 tw-w-5" aria-hidden="true" />
//         </Menu.Button>
//       </div>
//
//       <Transition
//         as={Fragment}
//         enter="tw-transition tw-ease-out tw-duration-100"
//         enterFrom="tw-transform tw-opacity-0 tw-scale-95"
//         enterTo="tw-transform tw-opacity-100 tw-scale-100"
//         leave="tw-transition tw-ease-in tw-duration-75"
//         leaveFrom="tw-transform tw-opacity-100 tw-scale-100"
//         leaveTo="tw-transform tw-opacity-0 tw-scale-95"
//       >
//         <Menu.Items className="tw-origin-top-right tw-absolute tw-right-0 tw-mt-2 tw-w-56 tw-rounded-md tw-shadow-lg tw-bg-white tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
//           <div className="tw-py-1">
//             <Menu.Item>
//               {({ active }) => (
//                 <a
//                   href="#"
//                   className={classNames(
//                     active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
//                     'tw-block tw-px-4 tw-py-2 tw-text-sm'
//                   )}
//                 >
//                   Account settings
//                 </a>
//               )}
//             </Menu.Item>
//             <Menu.Item>
//               {({ active }) => (
//                 <a
//                   href="#"
//                   className={classNames(
//                     active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
//                     'tw-block tw-px-4 tw-py-2 tw-text-sm'
//                   )}
//                 >
//                   Support
//                 </a>
//               )}
//             </Menu.Item>
//             <Menu.Item>
//               {({ active }) => (
//                 <a
//                   href="#"
//                   className={classNames(
//                     active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
//                     'tw-block tw-px-4 tw-py-2 tw-text-sm'
//                   )}
//                 >
//                   License
//                 </a>
//               )}
//             </Menu.Item>
//             <form method="POST" action="#">
//               <Menu.Item>
//                 {({ active }) => (
//                   <button
//                     type="submit"
//                     className={classNames(
//                       active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
//                       'tw-block tw-w-full tw-text-left tw-px-4 tw-py-2 tw-text-sm'
//                     )}
//                   >
//                     Sign out
//                   </button>
//                 )}
//               </Menu.Item>
//             </form>
//           </div>
//         </Menu.Items>
//       </Transition>
//     </Menu>
//   )
// }


// import { Menu } from '@headlessui/react'
//
// export default function TestDropdown() {
//   return (
//     <Menu>
//       <Menu.Button>More</Menu.Button>
//       <Menu.Items>
//         <Menu.Item>
//           {({ active }) => (
//             <a
//               className={`${active && 'tw-bg-blue-500'}`}
//               href="/account-settings"
//             >
//               Account settings
//             </a>
//           )}
//         </Menu.Item>
//         <Menu.Item>
//           {({ active }) => (
//             <a
//               className={`${active && 'tw-bg-blue-500'}`}
//               href="/account-settings"
//             >
//               Documentation
//             </a>
//           )}
//         </Menu.Item>
//         <Menu.Item disabled>
//           <span className="tw-opacity-75">Invite a friend (coming soon!)</span>
//         </Menu.Item>
//       </Menu.Items>
//     </Menu>
//   )
// }
