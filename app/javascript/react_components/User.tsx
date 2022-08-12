/* This example requires Tailwind CSS v2.0+ */
import * as React from "react";
import {Fragment} from 'react'
import {Menu, Transition} from '@headlessui/react'
import {ChevronDownIcon, GlobeAltIcon, GlobeIcon, LoginIcon, UserIcon} from '@heroicons/react/solid'

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

function Icon(props: {title: string}) {
  switch(props.title) {
    case 'login':
      return <LoginIcon className="tw-w-5 tw-h-5"></LoginIcon>
  }
}

export default function User(
  props: {
    user_id: string,
    avatar: string,
    name: string,
    email: string
    links: {title: string, url: string, icon: string, dataMethod: string}[]
}) {
  if (props.user_id) {
    return (
      <Menu as="div" className="tw-relative tw-text-left tw-text-sm !tw-no-underline tw-text-gray-500 focus-within:!tw-text-gray-400">
        <Menu.Button data-test-id="user-component" className="tw-flex !tw-outline-0">
          <span className="tw-inline-block">
            <img className="tw-rounded tw-w-[32px] tw-h-[32px]" src={props.avatar} />
          </span>
          <div className="tw-hidden tw-flex tw-place-self-center xl:tw-block tw-text-left hover:!tw-text-gray-400 tw-ml-1.5">
            <div className="tw-leading-4 tw-text-sm !tw-no-underline"># {props.user_id} {props.name}</div>
            <div className="tw-leading-4 tw-text-xs !tw-no-underline">{props.email}</div>
          </div>
        </Menu.Button>

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
            className="tw-z-10 tw-origin-top-right tw-absolute tw-right-0 tw-mt-2 tw-w-56 tw-rounded-md tw-shadow-lg tw-bg-white tw-ring-1 tw-ring-black tw-ring-opacity-5 focus:tw-outline-none">
            <div className="tw-py-1">
              {props.links && props.links.length > 0 && props.links.map((link) => {
                return (
                  <Menu.Item key={link.title}>
                    {({active}) => (
                      <a
                        href={link.url}
                        data-turbo-method={link.method}
                        className={classNames(
                          active ? 'tw-bg-gray-100 tw-text-gray-900' : 'tw-text-gray-500',
                          'tw-block tw-px-4 tw-py-2 tw-text-sm !tw-no-underline hover:!tw-text-gray-400'
                        )}
                      >
                        {link.title}
                      </a>
                    )}
                  </Menu.Item>
                )
              })}
            </div>
          </Menu.Items>
        </Transition>
      </Menu>
    )}
  else {
    return (
      <div className="tw-relative tw-inline-block tw-text-left tw-text-sm">
        <div>
          <a href={props.links[0].url} className="!tw-no-underline tw-text-gray-500 hover:tw-text-gray-400">
            <span className="tw-inline-block tw-align-top tw-mr-1.5">
              <Icon title={props.links[0].icon}></Icon>
            </span>
            <span>{ props.links[0].title }</span>
          </a>
        </div>
      </div>
    )
  }
}
