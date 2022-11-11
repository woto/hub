import { Menu, Transition } from '@headlessui/react';
import { BarsArrowUpIcon } from '@heroicons/react/24/outline';
import { Fragment } from 'react';
import * as React from 'react';

const sortOptions = [
  { name: 'Релевантность', href: '#' },
  { name: 'Дата упоминания', href: '#' },
  { name: 'Дата обнаружения', href: '#' },
];

export default function Sort() {
  return (
    <Menu as="div" className="tw-z-10 tw-inline-block tw-text-left">
      <div>
        <Menu.Button className="tw-rounded-sm tw-ring-offset-2 tw-group tw-inline-flex tw-justify-center
        tw-text-gray-700 hover:tw-text-gray-900 focus:tw-ring-indigo-300 focus:tw-ring-2 tw-outline-none"
        >
          <BarsArrowUpIcon
            className="tw-flex-shrink-0 tw-h-6 tw-w-6 tw-text-gray-400 group-hover:tw-text-gray-600"
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
        <Menu.Items className="tw-origin-top-right tw-absolute tw-right-0 tw-z-10 tw-mt-[21px] tw-w-48
        tw-bg-slate-50  tw-ring-1 tw-ring-gray-200 focus:tw-outline-none"
        >
          <div className="tw-py-1">
            {sortOptions.map((option) => (
              <Menu.Item key={option.name}>
                {({ active }) => (
                  <a
                    href={option.href}
                    className={`
                      ${active ? 'tw-bg-white' : ''}
                      tw-block tw-px-4 tw-py-2 tw-text-sm tw-font-medium tw-text-gray-700
                    `}
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
  );
}
