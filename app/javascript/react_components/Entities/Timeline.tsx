/* This example requires Tailwind CSS v2.0+ */
import {Fragment, useRef, useState} from 'react'
import { QueryClient, QueryClientProvider, useQuery } from "react-query";
import axios from "axios";
import {Dialog, Transition} from '@headlessui/react'
import {XIcon} from '@heroicons/react/outline'
import {ClockIcon} from '@heroicons/react/solid'
import * as React from "react"
import Cite from "../Cites/Cite";

const tabs = [
  {name: 'Все', href: '#', current: true},
  {name: 'Мои', href: '#', current: false},
]

export default function Timeline(props: { entityId: number }) {
  const { isLoading, error, data, isFetching } = useQuery(`cites:${props.entityId}`, () => {
    const query = new URLSearchParams({
      entity_id: props.entityId.toString()
    });

    return axios
      .get(`/api/cites/?${query}`)
      .then((res) => res.data)
  });

  const [open, setOpen] = useState(false)

  return (
    <>
      <button
        type="button"
        className="tw-flex tw-rounded-md tw-bg-white tw-text-indigo-400 hover:tw-text-indigo-500 focus:tw-ring-2 focus:tw-ring-indigo-500"
        onClick={(e) => { e.preventDefault(); setOpen(true); }}
      >
        <ClockIcon className="tw-h-6 tw-w-6 tw-mr-2" aria-hidden="true"/>
        История изменений
      </button>

      <Transition.Root show={open} as={Fragment}>
        <Dialog as="div" className="tw-fixed tw-inset-0 tw-overflow-hidden" onClose={setOpen}>
          <div className="tw-absolute tw-inset-0 tw-overflow-hidden">
            <Dialog.Overlay className="tw-absolute tw-inset-0"/>

            <div
              className="tw-pointer-events-none tw-fixed tw-inset-y-0 tw-right-0 tw-flex tw-max-w-full tw-pl-10 sm:tw-pl-16">
              <Transition.Child
                as={Fragment}
                enter="tw-transform tw-transition tw-ease-in-out tw-duration-500 sm:tw-duration-700"
                enterFrom="tw-translate-x-full"
                enterTo="tw-translate-x-0"
                leave="tw-transform tw-transition tw-ease-in-out tw-duration-500 sm:tw-duration-700"
                leaveFrom="tw-translate-x-0"
                leaveTo="tw-translate-x-full"
              >
                <div className="tw-pointer-events-auto tw-w-screen tw-max-w-md">
                  <div
                    className="tw-flex tw-h-full tw-flex-col tw-overflow-y-scroll tw-bg-white tw-shadow-xl">
                    <div className="tw-p-6">
                      <div className="tw-flex tw-items-start tw-justify-between">
                        <Dialog.Title className="tw-text-lg tw-font-medium tw-text-gray-900"> Название </Dialog.Title>
                        <div className="tw-ml-3 tw-flex tw-h-7 tw-items-center">
                          <button
                            type="button"
                            className="tw-rounded-md tw-bg-white tw-text-gray-400 hover:tw-text-gray-500 focus:tw-ring-2 focus:tw-ring-indigo-500"
                            onClick={() => setOpen(false)}
                          >
                            <span className="tw-sr-only">Close panel</span>
                            <XIcon className="tw-h-6 tw-w-6" aria-hidden="true"/>
                          </button>
                        </div>
                      </div>
                    </div>
                    <div className="tw-border-b tw-border-gray-200">
                      <div className="tw-px-6">
                        <nav className="-tw-mb-px tw-flex tw-space-x-6">
                          {tabs.map((tab) => (
                            <a
                              key={tab.name}
                              href={tab.href}
                              className={`
                                ${tab.current 
                                ? 'tw-border-indigo-500 tw-text-indigo-600'
                                : 'tw-border-transparent tw-text-gray-500 hover:tw-text-gray-700 hover:tw-border-gray-300'}
                                tw-whitespace-nowrap tw-pb-4 tw-px-1 tw-border-b-2 tw-font-medium tw-text-sm
                              `}
                            >
                              {tab.name}
                            </a>
                          ))}
                        </nav>
                      </div>
                    </div>
                    <div className="tw-flow-root tw-px-6 tw-pt-6">
                      <ul className="-tw-mb-8">
                        {data && data.length > 0 && data.map((cite: any) =>
                          <Cite key={cite.id} {...cite}></Cite>
                        )}
                      </ul>
                    </div>
                  </div>
                </div>
              </Transition.Child>
            </div>
          </div>
        </Dialog>
      </Transition.Root>
    </>
  )
}