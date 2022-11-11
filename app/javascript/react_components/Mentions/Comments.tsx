import * as React from 'react';
import { Fragment, useState } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { XIcon } from '@heroicons/react/outline';
import { XMarkIcon } from '@heroicons/react/24/solid';

export default function Comments(props: {
  open: boolean,
  setOpen: React.Dispatch<React.SetStateAction<boolean>>
}) {
  return (
    <Transition.Root show={props.open} as={Fragment}>
      <Dialog as="div" className="tw-fixed tw-inset-0 tw-overflow-hidden tw-z-40" onClose={props.setOpen}>
        <div className="tw-absolute tw-inset-0 tw-overflow-hidden">
          <Transition.Child
            as={Fragment}
            enter="tw-ease-out tw-duration-300"
            enterFrom="tw-opacity-0"
            enterTo="tw-opacity-100"
            leave="tw-ease-in tw-duration-200"
            leaveFrom="tw-opacity-100"
            leaveTo="tw-opacity-0"
          >
            <Dialog.Overlay className="tw-fixed tw-inset-0 tw-bg-slate-500/50" />
          </Transition.Child>

          <div className="tw-pointer-events-none tw-fixed tw-inset-y-0 tw-right-0 tw-flex tw-max-w-full tw-pl-10">
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
                <div className="tw-flex tw-h-full tw-flex-col tw-overflow-y-scroll tw-bg-white tw-py-6 tw-shadow-xl">
                  <div className="tw-px-4 sm:tw-px-6">
                    <div className="tw-flex tw-items-start tw-justify-between">
                      <Dialog.Title className="tw-text-lg tw-font-medium tw-text-gray-900"> Комментарии </Dialog.Title>
                      <div className="tw-ml-3 tw-flex tw-h-7 tw-items-center">
                        <button
                          type="button"
                          className="tw-rounded-md tw-bg-white tw-text-gray-400 hover:tw-text-gray-500
                          focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300 focus:tw-ring-offset-2"
                          onClick={() => props.setOpen(false)}
                        >
                          <span className="tw-sr-only">Закрыть</span>
                          <XMarkIcon className="tw-h-6 tw-w-6" aria-hidden="true" />
                        </button>
                      </div>
                    </div>
                  </div>
                  <div className="tw-relative tw-mt-6 tw-flex-1 tw-px-4 sm:tw-px-6">
                    {/* Replace with your content */}
                    <div className="tw-absolute tw-inset-0 tw-px-4 sm:tw-px-6">
                      <div className="tw-h-full tw-border-2 tw-border-dashed tw-border-gray-200" aria-hidden="true" />
                    </div>
                    {/* /End replace */}
                  </div>
                </div>
              </div>
            </Transition.Child>
          </div>
        </div>
      </Dialog>
    </Transition.Root>
  );
}
