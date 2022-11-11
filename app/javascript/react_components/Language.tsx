import * as React from 'react';
import { Disclosure, Transition } from '@headlessui/react';
import { GlobeAltIcon } from '@heroicons/react/24/outline';
import { Fragment } from 'react';

export default function Example7(props: {
  languages: any
 }) {
  return (
    <Disclosure>
      <Disclosure.Button
        data-test-id="language-component"
        className="
          tw-w-full
          lg:tw-text-sm
          tw-text-gray-500 hover:tw-text-gray-700 tw-group tw-flex tw-items-center tw-px-2 tw-py-2 tw-text-base tw-font-medium tw-rounded-md"
      >
        <GlobeAltIcon className="lg:tw-mr-3 tw-mr-4 tw-h-6 tw-w-6" />
        Language
      </Disclosure.Button>

      <Transition
        as={Fragment}
        enter="tw-transition tw-duration-100 tw-ease-out"
        enterFrom="tw-transform tw-scale-95 tw-opacity-0"
        enterTo="tw-transform tw-scale-100 tw-opacity-100"
        leave="tw-transition tw-duration-75 tw-ease-out"
        leaveFrom="tw-transform tw-scale-100 tw-opacity-100"
        leaveTo="tw-transform tw-scale-95 tw-opacity-0"
      >
        <Disclosure.Panel as="ul" className="!tw-mt-0">
          {props.languages && props.languages.length > 0 && props.languages.map((language) => (
            <li
              className=""
              key={language.title}
            >
              <a
                href={language.url}
                className={`
                tw-text-base lg:tw-text-sm
                tw-text-gray-600 hover:tw-text-gray-900 tw-group tw-flex tw-items-center tw-px-2 tw-py-2 tw-font-medium tw-rounded-md
              `}
              >
                {language.title}
              </a>
            </li>
          ))}
        </Disclosure.Panel>
      </Transition>
    </Disclosure>
  );
}
