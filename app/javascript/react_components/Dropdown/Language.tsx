/* This example requires Tailwind CSS v2.0+ */
import React from 'react';
import { Fragment } from 'react'
import { Menu, Transition } from '@headlessui/react'
import { ChevronDownIcon } from '@heroicons/react/solid'

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

export default function Language(props: {languages: any}) {
  return (
    <Menu as="div" className="tw-relative tw-inline-block tw-text-left">
      <div>
        {/*<Menu.Button className="tw-inline-flex tw-justify-center tw-w-full tw-rounded-md tw-border tw-border-gray-300 tw-shadow-sm tw-px-4 tw-py-2 tw-bg-white tw-text-sm tw-font-medium tw-text-gray-700 hover:tw-bg-gray-50 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-offset-gray-100 focus:tw-ring-indigo-500">*/}
        <Menu.Button data-test-id="language-component" className="">
          <i className="fas fa-globe fa-lg xl:tw-mr-2"></i>
          <span className="tw-hidden xl:tw-inline">{props.title}</span>
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
        <Menu.Items className="tw-z-10 tw-origin-top-right tw-absolute tw-right-0 tw-mt-2 tw-w-56 tw-rounded-md tw-shadow-lg tw-bg-white tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
          <div className="tw-py-1">
            { props.languages && props.languages.length > 0 && props.languages.map((language) => {
              return (
              <Menu.Item key={language.title}>
                {({ active }) => (
                  <a
                    href={language.url}
                    className={classNames(
                      active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                      'tw-block tw-px-4 tw-py-2 tw-text-sm'
                    )}
                  >
                    {language.title}
                  </a>
                )}
              </Menu.Item>
              )
            })}
          </div>
        </Menu.Items>
      </Transition>
    </Menu>
  )
}
