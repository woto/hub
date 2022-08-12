/*
  This example requires Tailwind CSS v2.0+

  This example requires some changes to your config:

  ```
  // tailwind.config.js
  module.exports = {
    // ...
    plugins: [
      // ...
      require('@tailwindcss/forms'),
    ],
  }
  ```
*/

import * as React from "react";
import {Fragment} from 'react'
import {Disclosure, Menu, Transition} from '@headlessui/react'
import {SearchIcon} from '@heroicons/react/solid'
import {BellIcon, MenuIcon, XIcon} from '@heroicons/react/outline'
import Language from "./Dropdown/Language";
import SearchBar from "./SearchBar";
import User from "./User";

const user = {
  name: 'Tom Cook',
  email: 'tom@example.com',
  imageUrl:
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
}
const userNavigation = [
  {name: 'Your Profile', href: '#'},
  {name: 'Settings', href: '#'},
  {name: 'Sign out', href: '#'},
]

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

export default function Mentions(props: {
  logoSrc: string,
  searchBar: {
    q: string,
    buttonTitle: string,
    items: any[],
    placeholder: string
  },
  language: {
    languages: any,
    color: string,
    size: number,
    title: string
  }
  navigation: {
    title: string,
    url: string,
    current: boolean
  }[]
}) {
  return (
    <>
      <div className="tw-min-h-full?">
        <Disclosure as="nav"
                    className="tw-bg-gray-800 lg:tw-bg-neutral-100 tw-border-b tw-border-neutral-200 tw-border-opacity-25 tw-lg:border-none">
          {({open}) => (
            <>
              <div className="tw-max-w-7xl tw-mx-auto tw-px-2 sm:tw-px-4 lg:tw-px-8">
                <div
                  className="tw-relative tw-h-16 tw-flex tw-items-center tw-justify-between lg:tw-border-b lg:tw-border-neutral-50 lg:tw-border-opacity-25">
                  <div className="tw-px-0 tw-flex tw-items-center lg:tw-px-0">
                    <div className="tw-flex-shrink-0">
                      <img
                        className="tw-block tw-h-10 tw-w-10"
                        src={props.logoSrc}
                      />
                    </div>
                    <div className="tw-hidden lg:tw-block lg:tw-ml-10">
                      <div className="tw-flex tw-space-x-4">
                        {props.navigation.map((item) => (
                          <a
                            key={item.title}
                            href={item.url}
                            className={classNames(
                              item.current
                                ? 'tw-text-white tw-shadow-inner tw-bg-indigo-500'
                                : 'tw-text-slate-800 tw-bg-white tw-shadow-md hover:tw-shadow focus:tw-shadow-sm',
                              'tw-rounded-md tw-py-2 tw-px-3 tw-text-sm tw-font-medium'
                            )}
                            aria-current={item.current ? 'page' : undefined}
                          >
                            {item.title}
                          </a>
                        ))}
                      </div>
                    </div>
                  </div>
                  <div className="tw-flex-1 tw-px-2 tw-flex tw-justify-center lg:tw-ml-6 lg:tw-justify-end">
                    <div className="tw-max-w-lg tw-w-full lg:tw-max-w-xs">
                      <SearchBar {...props.searchBar} />
                      {false &&
                        <>
                          <label htmlFor="search" className="tw-sr-only">
                            Search
                          </label>
                          <div className="tw-relative tw-text-gray-400 focus-within:tw-text-gray-600">
                            <div
                              className="tw-pointer-events-none tw-absolute tw-inset-y-0 tw-left-0 tw-pl-3 tw-flex tw-items-center">
                              <SearchIcon className="tw-h-5 tw-w-5" aria-hidden="true"/>
                            </div>
                            <input
                              id="search"
                              className="tw-block tw-w-full tw-bg-white tw-py-2 tw-pl-10 tw-pr-3 tw-border tw-border-transparent tw-rounded-md tw-leading-5 tw-text-gray-900 tw-placeholder-gray-500 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-offset-indigo-600 focus:tw-ring-white focus:tw-border-white sm:tw-text-sm"
                              placeholder="Search"
                              type="search"
                              name="search"
                            />
                          </div>
                        </>
                      }
                    </div>
                  </div>
                  <div className="tw-flex lg:tw-hidden">
                    {/* Mobile menu button */}
                    <Disclosure.Button
                      className="tw-bg-indigo-600 tw-p-2 tw-rounded-md tw-inline-flex tw-items-center tw-justify-center tw-text-indigo-200 hover:tw-text-white hover:tw-bg-indigo-500 hover:tw-bg-opacity-75 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-offset-indigo-600 focus:tw-ring-white">
                      <span className="tw-sr-only">Open main menu</span>
                      {open ? (
                        <XIcon className="tw-block tw-h-6 tw-w-6" aria-hidden="true"/>
                      ) : (
                        <MenuIcon className="tw-block tw-h-6 tw-w-6" aria-hidden="true"/>
                      )}
                    </Disclosure.Button>
                  </div>
                  <div className="tw-hidden lg:tw-block lg:tw-ml-4">
                    <div className="tw-flex tw-items-center tw-gap-6">

                      {false &&
                        <button
                          type="button"
                          className="tw-bg-indigo-600 tw-flex-shrink-0 tw-rounded-full tw-p-1 tw-text-indigo-200 hover:tw-text-white focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-offset-indigo-600 focus:tw-ring-white"
                        >
                          <span className="tw-sr-only">View notifications</span>
                          <BellIcon className="tw-h-6 tw-w-6" aria-hidden="true"/>
                        </button>
                      }

                      <Language {...props.language}></Language>

                      <User {...props.user}></User>

                      {/* Profile dropdown */}
                      {false &&
                        <Menu as="div" className="tw-ml-3 tw-relative tw-flex-shrink-0">
                          <div>
                            <Menu.Button
                              className="tw-bg-indigo-600 tw-rounded-full tw-flex tw-text-sm tw-text-white focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-offset-indigo-600 focus:tw-ring-white">
                              <span className="tw-sr-only">Open user menu</span>
                              <img className="tw-rounded-full tw-h-8 tw-w-8" src={user.imageUrl} alt=""/>
                            </Menu.Button>
                          </div>
                          <Transition
                            as={Fragment}
                            enter="tw-transition tw-ease-out tw-duration-100"
                            enterFrom="tw-transform tw-opacity-0 tw-scale-95"
                            enterTo="tw-transform tw-opacity-100 tw-scale-100"
                            leave="tw-transition tw-ease-in tw-duration-75"
                            leaveFrom="tw-transform tw-opacity-100 tw-scale-100"
                            leaveTo="tw-transform tw-opacity-0 tw-scale-95"
                          >
                            <Menu.Items
                              className="tw-origin-top-right tw-absolute tw-right-0 tw-mt-2 tw-w-48 tw-rounded-md tw-shadow-lg tw-py-1 tw-bg-white tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
                              {userNavigation.map((item) => (
                                <Menu.Item key={item.name}>
                                  {({active}) => (
                                    <a
                                      href={item.href}
                                      className={classNames(
                                        active ? 'tw-bg-gray-100' : '',
                                        'tw-block tw-py-2 tw-px-4 tw-text-sm tw-text-gray-700'
                                      )}
                                    >
                                      {item.name}
                                    </a>
                                  )}
                                </Menu.Item>
                              ))}
                            </Menu.Items>
                          </Transition>
                        </Menu>
                      }
                    </div>
                  </div>
                </div>
              </div>

              <Disclosure.Panel className="lg:tw-hidden">
                <div className="tw-px-2 tw-pt-2 tw-pb-3 tw-space-y-1">
                  {props.navigation.map((item) => (
                    <Disclosure.Button
                      key={item.title}
                      as="a"
                      href={item.url}
                      className={classNames(
                        item.current
                          ? 'tw-bg-indigo-700 tw-text-white'
                          : 'tw-text-white hover:tw-bg-indigo-500 hover:tw-bg-opacity-75',
                        'tw-block tw-rounded-md tw-py-2 tw-px-3 tw-text-base tw-font-medium'
                      )}
                      aria-current={item.current ? 'page' : undefined}
                    >
                      {item.title}
                    </Disclosure.Button>
                  ))}
                </div>
                <div className="tw-pt-4 tw-pb-3 tw-border-t tw-border-indigo-700">
                  <div className="tw-px-5 tw-flex tw-items-center">
                    <div className="tw-flex-shrink-0">
                      <img className="tw-rounded-full tw-h-10 tw-w-10" src={user.imageUrl} alt=""/>
                    </div>
                    <div className="tw-ml-3">
                      <div className="tw-text-base tw-font-medium tw-text-white">{user.name}</div>
                      <div className="tw-text-sm tw-font-medium tw-text-indigo-300">{user.email}</div>
                    </div>

                    {false &&
                      <button
                        type="button"
                        className="tw-ml-auto tw-bg-indigo-600 tw-flex-shrink-0 tw-rounded-full tw-p-1 tw-text-indigo-200 hover:tw-text-white focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-offset-indigo-600 focus:tw-ring-white"
                      >
                        <span className="tw-sr-only">View notifications</span>
                        <BellIcon className="tw-h-6 tw-w-6" aria-hidden="true"/>
                      </button>
                    }
                  </div>
                  <div className="tw-mt-3 tw-px-2 tw-space-y-1">
                    {userNavigation.map((item) => (
                      <Disclosure.Button
                        key={item.name}
                        as="a"
                        href={item.href}
                        className="tw-block tw-rounded-md tw-py-2 tw-px-3 tw-text-base tw-font-medium tw-text-white hover:tw-bg-indigo-500 hover:tw-bg-opacity-75"
                      >
                        {item.name}
                      </Disclosure.Button>
                    ))}
                  </div>
                </div>
              </Disclosure.Panel>
            </>
          )}
        </Disclosure>
      </div>
    </>
  )
}
