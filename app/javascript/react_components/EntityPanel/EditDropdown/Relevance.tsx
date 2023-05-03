/* This example requires Tailwind CSS v2.0+ */
import { Fragment, useState } from 'react'
import * as React from 'react'
import { Listbox, Transition } from '@headlessui/react'
import {CheckIcon, ChevronDownIcon} from "@heroicons/react/24/outline";

const publishingOptions = [
  { title: 'Основная', description: '', current: true },
  { title: 'Любая', description: '', current: false },
]

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

export default function Relevance() {
  const [selected, setSelected] = useState(publishingOptions[0])

  return (
    <div className={'tw-text-left tw-relative tw-grid tw-grid-cols-2 tw-items-center'}>
      <div className={'tw-mb-1 tw-text-sm tw-font-medium tw-text-gray-700'}> Важность: </div>
      <Listbox value={selected} onChange={setSelected}>
        {({ open }) => (
          <>
            <Listbox.Label className="tw-sr-only">Change published status</Listbox.Label>
            <div className="tw-relative">
              <div className="tw-inline-flex  tw-rounded-md tw-divide-x tw-divide-indigo-600">
                <div className="tw-relative tw-z-0 tw-inline-flex  tw-rounded-md tw-divide-x tw-divide-indigo-600">
                  <div className="tw-relative tw-inline-flex tw-items-center tw-bg-gradient-to-b tw-from-gray-50 tw-to-gray-100 tw-py-2 tw-pl-3 tw-pr-4
                  tw-border tw-border-transparent tw-rounded-l-md  tw-text-slate-700">
                    <CheckIcon className="tw-h-5 tw-w-5" aria-hidden="true" />
                    <p className="tw-ml-2.5 tw-text-sm tw-font-medium">{selected.title}</p>
                  </div>
                  <Listbox.Button className="tw-relative tw-inline-flex tw-items-center tw-bg-indigo-500 tw-p-2
                  tw-rounded-l-none tw-rounded-r-md tw-text-sm tw-font-medium tw-text-white hover:tw-bg-indigo-600
                  focus:tw-outline-none focus:tw-z-10 focus:tw-ring-2 focus:tw-ring-offset-2
                  focus:tw-ring-offset-gray-50 focus:tw-ring-indigo-500">
                    <span className="tw-sr-only">Change published status</span>
                    <ChevronDownIcon className="tw-h-5 tw-w-5 tw-text-white" aria-hidden="true" />
                  </Listbox.Button>
                </div>
              </div>

              <Transition
                show={open}
                as={Fragment}
                leave="tw-transition tw-ease-in tw-duration-100"
                leaveFrom="tw-opacity-100"
                leaveTo="tw-opacity-0"
              >
                <Listbox.Options className="tw-origin-top-right tw-absolute tw-z-10
                tw-inset-x-0 tw-mt-2 tw-w-72 tw-rounded-md  tw-overflow-hidden tw-bg-white tw-divide-y
                tw-divide-gray-200 tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
                  {publishingOptions.map((option) => (
                    <Listbox.Option
                      key={option.title}
                      className={({ active }) =>
                        classNames(
                          active ? 'tw-text-white tw-bg-indigo-500' : 'tw-text-gray-900',
                          'tw-cursor-default tw-select-none tw-relative tw-p-4 tw-text-sm'
                        )
                      }
                      value={option}
                    >
                      {({ selected, active }) => (
                        <div className="tw-flex tw-flex-col">
                          <div className="tw-flex tw-justify-between">
                            <p className={selected ? 'tw-font-semibold' : 'tw-font-normal'}>{option.title}</p>
                            {selected ? (
                              <span className={active ? 'tw-text-white' : 'tw-text-indigo-500'}>
                                <CheckIcon className="tw-h-5 tw-w-5" aria-hidden="true" />
                              </span>
                            ) : null}
                          </div>
                          <p className={classNames(active ? 'tw-text-indigo-200' : 'tw-text-gray-500', 'tw-mt-2')}>
                            {option.description}
                          </p>
                        </div>
                      )}
                    </Listbox.Option>
                  ))}
                </Listbox.Options>
              </Transition>
            </div>
          </>
        )}
      </Listbox>
    </div>
  )
}
