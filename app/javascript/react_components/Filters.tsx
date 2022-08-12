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
import * as React from 'react';
import { Fragment, useState } from 'react'
import { Dialog, Disclosure, Menu, Popover, Transition } from '@headlessui/react'
import { XIcon } from '@heroicons/react/outline'
import { ChevronDownIcon } from '@heroicons/react/solid'

const sortOptions = [
  { name: 'Релевантность', href: '#' },
  { name: 'Дата упоминания', href: '#' },
  { name: 'Дата обнаружения', href: '#' },
]
const filters = [
  {
    id: 'category',
    name: 'Дата обнаружения',
    options: [
      { value: 'tees', label: 'Tees' },
      { value: 'crewnecks', label: 'Crewnecks' },
      { value: 'hats', label: 'Hats' },
    ],
  },
  {
    id: 'category',
    name: 'Дата упоминания',
    options: [
      { value: 'tees', label: 'Tees' },
      { value: 'crewnecks', label: 'Crewnecks' },
      { value: 'hats', label: 'Hats' },
    ],
  },
  {
    id: 'brand',
    name: 'Объекты',
    options: [
      { value: 'clothing-company', label: 'Clothing Company' },
      { value: 'fashion-inc', label: 'Fashion Inc.' },
      { value: 'shoes-n-more', label: "Shoes 'n More" },
    ],
  },
  {
    id: 'brand',
    name: 'Настроение',
    options: [
      { value: 'clothing-company', label: 'Clothing Company' },
      { value: 'fashion-inc', label: 'Fashion Inc.' },
      { value: 'shoes-n-more', label: "Shoes 'n More" },
    ],
  },
  {
    id: 'color',
    name: 'Важность',
    options: [
      { value: 'white', label: 'White' },
      { value: 'black', label: 'Black' },
      { value: 'grey', label: 'Grey' },
    ],
  },
  {
    id: 'sizes',
    name: 'Сайты',
    options: [
      { value: 's', label: 'S' },
      { value: 'm', label: 'M' },
      { value: 'l', label: 'L' },
    ],
  },
]

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

export default function Example() {
  const [open, setOpen] = useState(false)

  return (
    <div className="tw-bg-gray-50">
      {/* Mobile filter dialog */}
      <Transition.Root show={open} as={Fragment}>
        <Dialog as="div" className="tw-fixed tw-inset-0 tw-flex tw-z-40 sm:tw-hidden" onClose={setOpen}>
          <Transition.Child
            as={Fragment}
            enter="tw-transition-opacity tw-ease-linear tw-duration-300"
            enterFrom="tw-opacity-0"
            enterTo="tw-opacity-100"
            leave="tw-transition-opacity tw-ease-linear tw-duration-300"
            leaveFrom="tw-opacity-100"
            leaveTo="tw-opacity-0"
          >
            <Dialog.Overlay className="tw-fixed tw-inset-0 tw-bg-black tw-bg-opacity-25" />
          </Transition.Child>

          <Transition.Child
            as={Fragment}
            enter="tw-transition tw-ease-in-out tw-duration-300 tw-transform"
            enterFrom="tw-translate-x-full"
            enterTo="tw-translate-x-0"
            leave="tw-transition tw-ease-in-out tw-duration-300 tw-transform"
            leaveFrom="tw-translate-x-0"
            leaveTo="tw-translate-x-full"
          >
            <div className="tw-ml-auto tw-relative tw-max-w-xs tw-w-full tw-h-full tw-bg-white tw-shadow-xl tw-py-4 tw-pb-6 tw-flex tw-flex-col tw-overflow-y-auto">
              <div className="tw-px-4 tw-flex tw-items-center tw-justify-between">
                <h2 className="tw-text-lg tw-font-medium tw-text-gray-900">Filters</h2>
                <button
                  type="button"
                  className="-tw-mr-2 tw-w-10 tw-h-10 tw-bg-white tw-p-2 tw-rounded-md tw-flex tw-items-center tw-justify-center tw-text-gray-400 hover:tw-bg-gray-50 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-500"
                  onClick={() => setOpen(false)}
                >
                  <span className="tw-sr-only">Close menu</span>
                  <XIcon className="tw-h-6 tw-w-6" aria-hidden="true" />
                </button>
              </div>

              {/* Filters */}
              <form className="tw-mt-4">
                {filters.map((section) => (
                  <Disclosure as="div" key={section.name} className="tw-border-t tw-border-gray-200 tw-px-4 tw-py-6">
                    {({ open }) => (
                      <>
                        <h3 className="-tw-mx-2 -tw-my-3 tw-flow-root">
                          <Disclosure.Button className="tw-px-2 tw-py-3 tw-bg-white tw-w-full tw-flex tw-items-center tw-justify-between tw-text-sm tw-text-gray-400">
                            <span className="tw-font-medium tw-text-gray-900">{section.name}</span>
                            <span className="tw-ml-6 tw-flex tw-items-center">
                              <ChevronDownIcon
                                className={classNames(open ? '-tw-rotate-180' : 'tw-rotate-0', 'tw-h-5 tw-w-5 tw-transform')}
                                aria-hidden="true"
                              />
                            </span>
                          </Disclosure.Button>
                        </h3>
                        <Disclosure.Panel className="tw-pt-6">
                          <div className="tw-space-y-6">
                            {section.options.map((option, optionIdx) => (
                              <div key={option.value} className="tw-flex tw-items-center">
                                <input
                                  id={`filter-mobile-${section.id}-${optionIdx}`}
                                  name={`${section.id}[]`}
                                  defaultValue={option.value}
                                  type="checkbox"
                                  className="tw-h-4 tw-w-4 tw-border-gray-300 tw-rounded tw-text-indigo-600 focus:tw-ring-indigo-500"
                                />
                                <label
                                  htmlFor={`filter-mobile-${section.id}-${optionIdx}`}
                                  className="tw-ml-3 tw-text-sm tw-text-gray-500"
                                >
                                  {option.label}
                                </label>
                              </div>
                            ))}
                          </div>
                        </Disclosure.Panel>
                      </>
                    )}
                  </Disclosure>
                ))}
              </form>
            </div>
          </Transition.Child>
        </Dialog>
      </Transition.Root>

      <div className="tw-max-w-3xl tw-mx-auto tw-px-4 tw-text-center sm:tw-px-6 lg:tw-max-w-7xl lg:tw-px-8">
        <div className="tw-py-24">
          <h1 className="tw-text-4xl tw-font-extrabold tw-tracking-tight tw-text-gray-900">New Arrivals</h1>
          <p className="tw-mt-4 tw-max-w-3xl tw-mx-auto tw-text-base tw-text-gray-500">
            Thoughtfully designed objects for the workspace, home, and travel.
          </p>
        </div>

        <section aria-labelledby="filter-heading" className="tw-border-t tw-border-gray-200 tw-py-6">
          <h2 id="filter-heading" className="tw-sr-only">
            Product filters
          </h2>

          <div className="tw-flex tw-items-center tw-justify-between">
            <Menu as="div" className="tw-relative tw-z-10 tw-inline-block tw-text-left">
              <div>
                <Menu.Button className="tw-group tw-inline-flex tw-justify-center tw-text-sm tw-font-medium tw-text-gray-700 hover:tw-text-gray-900">
                  Сортировка
                  <ChevronDownIcon
                    className="tw-flex-shrink-0 -tw-mr-1 tw-ml-1 tw-h-5 tw-w-5 tw-text-gray-400 group-hover:tw-text-gray-500"
                    aria-hidden="true"
                  />
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
                <Menu.Items className="tw-origin-top-left tw-absolute tw-left-0 tw-z-10 tw-mt-2 tw-w-40 tw-rounded-md tw-shadow-2xl tw-bg-white tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
                  <div className="tw-py-1">
                    {sortOptions.map((option) => (
                      <Menu.Item key={option}>
                        {({ active }) => (
                          <a
                            href={option.href}
                            className={classNames(
                              active ? 'tw-bg-gray-100' : '',
                              'tw-block tw-px-4 tw-py-2 tw-text-sm tw-font-medium tw-text-gray-900'
                            )}
                          >
                            {option.name}
                          </a>
                        )}
                      </Menu.Item>
                    ))}
                  </div>
                </Menu.Items>
              </Transition>
            </Menu>

            <button
              type="button"
              className="tw-inline-block tw-text-sm tw-font-medium tw-text-gray-700 hover:tw-text-gray-900 sm:tw-hidden"
              onClick={() => setOpen(true)}
            >
              Filters
            </button>

            <Popover.Group className="tw-hidden sm:tw-flex sm:tw-items-baseline sm:tw-space-x-8">
              {filters.map((section, sectionIdx) => (
                <Popover as="div" key={section.name} id="desktop-menu" className="tw-relative tw-z-10 tw-inline-block tw-text-left">
                  <div>
                    <Popover.Button className="tw-group tw-inline-flex tw-items-center tw-justify-center tw-text-sm tw-font-medium tw-text-gray-700 hover:tw-text-gray-900">
                      <span>{section.name}</span>
                      {sectionIdx === 0 ? (
                        <span className="tw-ml-1.5 tw-rounded tw-py-0.5 tw-px-1.5 tw-bg-gray-200 tw-text-xs tw-font-semibold tw-text-gray-700 tw-tabular-nums">
                          1
                        </span>
                      ) : null}
                      <ChevronDownIcon
                        className="tw-flex-shrink-0 -tw-mr-1 tw-ml-1 tw-h-5 tw-w-5 tw-text-gray-400 group-hover:tw-text-gray-500"
                        aria-hidden="true"
                      />
                    </Popover.Button>
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
                    <Popover.Panel className="tw-origin-top-right tw-absolute tw-right-0 tw-mt-2 tw-bg-white tw-rounded-md tw-shadow-2xl tw-p-4 tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
                      <form className="tw-space-y-4">
                        {section.options.map((option, optionIdx) => (
                          <div key={option.value} className="tw-flex tw-items-center">
                            <input
                              id={`filter-${section.id}-${optionIdx}`}
                              name={`${section.id}[]`}
                              defaultValue={option.value}
                              type="checkbox"
                              className="tw-h-4 tw-w-4 tw-border-gray-300 tw-rounded tw-text-indigo-600 focus:tw-ring-indigo-500"
                            />
                            <label
                              htmlFor={`filter-${section.id}-${optionIdx}`}
                              className="tw-ml-3 tw-pr-6 tw-text-sm tw-font-medium tw-text-gray-900 tw-whitespace-nowrap"
                            >
                              {option.label}
                            </label>
                          </div>
                        ))}
                      </form>
                    </Popover.Panel>
                  </Transition>
                </Popover>
              ))}
            </Popover.Group>
          </div>
        </section>
      </div>
    </div>
  )
}
