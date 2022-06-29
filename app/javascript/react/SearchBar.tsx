import React, { RefObject, useCallback, useEffect, useRef, useState } from 'react';
import { Fragment } from 'react'
import { Menu, Transition } from '@headlessui/react'
import { XIcon } from '@heroicons/react/solid';
import { Turbo, cable } from "@hotwired/turbo-rails"

function classNames(...classes) {
  return '!tw-no-underline ' + classes.filter(Boolean).join(' ')
}

export default function SearchBar(props: { q: string, buttonTitle: string, items: any[], placeholder: string }) {

  const inputRef = useRef<HTMLInputElement>();
  const buttonRef = useRef<HTMLButtonElement>();

  const onChangeRef = useCallback((node: HTMLButtonElement) => {
    if (node) buttonRef.current = node;
  }, [])

  const visitUrl = (e: any, path: string) => {
    e.preventDefault();

    const url = new URL(path);
    if (q) url.searchParams.set('q', q);
    Turbo.visit(url.toString());
  }

  const expandOrVisit = (e: React.KeyboardEvent<HTMLButtonElement>) => {
    if (['Enter'].includes(e.key)) {
      e.preventDefault();
      buttonRef.current.click();
    }
  }

  const clearInput = () => {
    setQ('');
    inputRef.current.focus();
  }

  const [q, setQ] = useState<string>(props.q || '');

  return (

    <div className="tw-flex tw-rounded-md tw-shadow-sm">

      <div className="tw-relative tw-flex tw-items-stretch tw-flex-grow focus-within:tw-z-10">
        <input type="text"
          value={q}
          ref={inputRef}
          onChange={(e) => setQ(e.target.value)}
          onKeyDown={(e) => expandOrVisit(e)}
          placeholder={props.placeholder}
          data-react="search-text"
          className='tw-text-sm tw-border-gray-700 lg:tw-border-gray-300 tw-bg-slate-900 lg:tw-bg-white focus:tw-ring-indigo-500 focus:tw-border-indigo-500 tw-block tw-w-full tw-rounded-none tw-rounded-l-md' />

        <div className="tw-absolute tw-inset-y-0 tw-right-0 tw-flex tw-py-1.5 tw-pr-1.5">
          <button
            className=" hover:tw-text-gray-400 focus:tw-text-gray-600 tw-inline-flex tw-items-center tw-rounded tw-px-2 focus:tw-outline-0"
            onClick={clearInput}
          >
            <XIcon className="tw-w-4 tw-h-4" />
          </button>
        </div>
      </div>

      <Menu
        as="div"
        className="tw-relative tw-inline-block tw-text-left">

        <div>
          <Menu.Button
            ref={onChangeRef}
            onClick={(e) => { props.items.length === 1 && visitUrl(e, props.items[0].url) }}
            className="tw-justify-center tw-w-full hover:tw-bg-gray-900 lg:hover:tw-bg-gray-100 tw-border tw-border-gray-700 lg:tw-border-gray-300 tw-text-gray-300 lg:tw-text-gray-700 tw-bg-gray-700 lg:tw-bg-gray-50 -tw-ml-px tw-relative tw-inline-flex tw-items-center tw-space-x-2 tw-px-4 tw-py-2.5 tw-font-medium tw-rounded-r-md focus:tw-outline-none focus:tw-ring-1 focus:tw-ring-indigo-500 focus:tw-border-indigo-500">
            {props.buttonTitle}
          </Menu.Button>
        </div>

        {props.items.length > 1 &&

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
              static
              className="tw-z-10 tw-min-w-[300px] tw-origin-top-right tw-absolute tw-right-0 tw-mt-2 tw-w-56 tw-rounded-md tw-shadow-lg tw-bg-white tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
              <div className="tw-py-1">
                {props.items.map((item) => {
                  return (
                    <Menu.Item key={item.title}>
                      {({ active }) => (
                        <button
                          className={classNames(
                            active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-700',
                            'tw-block tw-w-full tw-text-left tw-px-4 tw-py-2 tw-text-sm')}
                          onClick={(e) => visitUrl(e, item.url)}
                        >
                          {item.title}
                        </button>
                      )}
                    </Menu.Item>
                  )
                })}
              </div>
            </Menu.Items>
          </Transition>
        }
      </Menu>
    </div>
  )
}
