import { XMarkIcon } from '@heroicons/react/20/solid';
import { Dialog, Transition } from '@headlessui/react';
import * as React from 'react';
import { useContext } from 'react';
import User from '../User';
import Example5 from '../Search/Button';
import Example7 from './Example7';
import Language from '../Language';
import Search from '../Search/Button';
import SidebarContext from './Context';
import { SidebarInterface } from '../system/TypeScript';
import ApiDocs from '../ApiDocs';
import LanguageContext from '../Language/LanguageContext';
import AllMentions from './AllMentions';
import Tinder from '../Tinder';

export default function DesktopSidebar(props: {language: any}) {
  const sidebarContext = React.useContext<SidebarInterface>(SidebarContext);
  const language = useContext(LanguageContext);
  return (
    <Transition.Root show={sidebarContext.sidebarOpen} as={React.Fragment}>
      <Dialog as="div" className="tw-fixed tw-inset-0 tw-flex tw-z-40 lg:tw-hidden" onClose={sidebarContext.setSidebarOpen}>
        <Transition.Child
          as={React.Fragment}
          enter="tw-transition-opacity tw-ease-linear tw-duration-300"
          enterFrom="tw-opacity-0"
          enterTo="tw-opacity-100"
          leave="tw-transition-opacity tw-ease-linear tw-duration-300"
          leaveFrom="tw-opacity-100"
          leaveTo="tw-opacity-0"
        >
          <Dialog.Overlay className="tw-fixed tw-inset-0 tw-bg-slate-500/50" />
        </Transition.Child>
        <Transition.Child
          as={React.Fragment}
          enter="tw-transition tw-ease-in-out tw-duration-300 tw-transform"
          enterFrom="-tw-translate-x-full"
          enterTo="tw-translate-x-0"
          leave="tw-transition tw-ease-in-out tw-duration-300 tw-transform"
          leaveFrom="tw-translate-x-0"
          leaveTo="-tw-translate-x-full"
        >
          <div className="tw-relative tw-flex-1 tw-flex tw-flex-col tw-max-w-xs tw-w-full tw-bg-white focus:tw-outline-none">
            <Transition.Child
              as={React.Fragment}
              enter="tw-ease-in-out tw-duration-300"
              enterFrom="tw-opacity-0"
              enterTo="tw-opacity-100"
              leave="tw-ease-in-out tw-duration-300"
              leaveFrom="tw-opacity-100"
              leaveTo="tw-opacity-0"
            >
              <div className="tw-absolute tw-top-0 tw-right-0 -tw-mr-12 tw-pt-2">
                <button
                  type="button"
                  className="tw-ml-1 tw-flex tw-items-center tw-justify-center tw-h-10 tw-w-10 tw-rounded-full focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-inset focus:tw-ring-white"
                  onClick={() => sidebarContext.setSidebarOpen(false)}
                >
                  <span className="tw-sr-only">Close sidebar</span>
                  <XMarkIcon className="tw-h-6 tw-w-6 tw-text-white" aria-hidden="true" />
                </button>
              </div>
            </Transition.Child>
            <div className="tw-flex-1 tw-h-0 tw-pt-5 tw-pb-4 tw-overflow-y-auto">
              <div className="tw-flex-shrink-0 tw-flex tw-items-center tw-px-4">
                <img
                  className="tw-h-7 tw-w-auto"
                  src="/roastme-full.svg"
                  alt="RoastMe.ru (logo)"
                />
              </div>
              <nav aria-label="Sidebar" className="tw-mt-5">
                <div className="tw-px-2 tw-space-y-1">

                  <div className="tw-mb-4">
                    <Search />
                  </div>

                  <AllMentions />

                  {sidebarContext.navigation.map((item) => (
                    <a
                      key={item.id}
                      href={`${language.path}/listings/${item.id}`}
                      className={`
                        ${item.current
                        ? 'tw-bg-gray-100 tw-text-gray-900'
                        : 'tw-text-gray-600 hover:tw-bg-gray-50 hover:tw-text-gray-900'}
                        tw-group tw-flex tw-items-center tw-px-2 tw-py-2 tw-text-base tw-font-medium tw-rounded-md tw-break-all
                      `}
                    >
                      <item.icon
                        className={`
                          ${item.current ? 'tw-text-gray-400' : 'tw-text-gray-300 group-hover:tw-text-gray-400'}
                          tw-mr-4 tw-h-6 tw-w-6 tw-shink-0
                        `}
                        aria-hidden="true"
                      />
                      {item.name}
                    </a>
                  ))}

                  <hr className="!tw-my-4 tw-h-px tw-bg-gray-200 tw-border-0 dark:tw-bg-gray-700" />

                  <div className="tw-space-y-2.5">
                    <Language {...props.language} />
                    <ApiDocs />
                    <Tinder />
                  </div>

                </div>
              </nav>
            </div>
            <div className="tw-flex-shrink-0 tw-flex tw-border-t tw-border-gray-200 tw-p-4">
              <User />
            </div>
          </div>
        </Transition.Child>
        <div className="tw-flex-shrink-0 tw-w-14" aria-hidden="true">
          {/* Force sidebar to shrink to fit close icon */}
        </div>
      </Dialog>
    </Transition.Root>
  );
}
