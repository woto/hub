/* This example requires Tailwind CSS v2.0+ */
import { Fragment } from 'react';
import * as React from 'react';
import { Popover, Transition } from '@headlessui/react';

import {
  BookmarkIcon,
  BriefcaseIcon,
  BuildingLibraryIcon, ChevronDownIcon, ComputerDesktopIcon,
  GlobeAltIcon,
  InformationCircleIcon,
  NewspaperIcon, PlusIcon,
  ShieldCheckIcon,
  UsersIcon,
} from '@heroicons/react/24/outline';
import { useQuery } from 'react-query';
import Entities from './Entities';
import axios from '../system/Axios';
import Entity from './Entity';

const company = [
  { name: 'About', href: '#', icon: InformationCircleIcon },
  { name: 'Customers', href: '#', icon: BuildingLibraryIcon },
  { name: 'Press', href: '#', icon: NewspaperIcon },
  { name: 'Careers', href: '#', icon: BriefcaseIcon },
  { name: 'Privacy', href: '#', icon: ShieldCheckIcon },
];
const resources = [
  { name: 'Community', href: '#', icon: UsersIcon },
  { name: 'Partners', href: '#', icon: GlobeAltIcon },
  { name: 'Guides', href: '#', icon: BookmarkIcon },
  { name: 'Webinars', href: '#', icon: ComputerDesktopIcon },
];
const blogPosts = [
  {
    id: 1,
    name: 'Boost your conversion rate',
    href: '#',
    preview: 'Eget ullamcorper ac ut vulputate fames nec mattis pellentesque elementum. Viverra tempor id mus.',
    imageUrl:
      'https://images.unsplash.com/photo-1558478551-1a378f63328e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2849&q=80',
  },
  {
    id: 2,
    name: 'How to use search engine optimization to drive traffic to your site',
    href: '#',
    preview: 'Eget ullamcorper ac ut vulputate fames nec mattis pellentesque elementum. Viverra tempor id mus.',
    imageUrl:
      'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2300&q=80',
  },
];

function classNames(...classes) {
  return classes.filter(Boolean).join(' ');
}

export default function AddCircle(props: {entityIds: number[], entityTitle: string, q: string}) {
  const {
    isLoading, error, data, isFetching,
  } = useQuery(`addCircle:${props.entityIds}`, () =>
    // if (props.entityIds) {
    axios
      .post('/api/entities/related', {
        entity_ids: props.entityIds,
        q: props.q,
        entity_title: props.entityTitle,
      })
      .then((res) => res.data),
    // }
  );

  return (
    <Popover className="tw-z-0 tw-relative?">
      {({ open }) => (
        <>
          {/* <div className="tw-relative tw-z-10 tw-bg-white tw-shadow"> */}
          {/*  <div className="tw-max-w-7xl tw-mx-auto tw-flex tw-px-4 tw-py-6 sm:tw-px-6 lg:tw-px-8"> */}
          <Popover.Button
            className="tw-relative tw-rounded-full focus:tw-ring-indigo-300 focus:tw-ring tw-outline-none"
          >
            <div
              className="tw-relative tw-inline-block tw-h-10 tw-w-10 tw-rounded-full
                  tw-bg-indigo-500 tw-border-2 tw-border-white tw-shadow
                  tw-inset-0 tw-absolute tw-z-50 tw-justify-center tw-items-center tw-flex"
            >
              <PlusIcon className="tw-text-white tw-w-5 tw-h-5" />
            </div>
          </Popover.Button>
          {/* </div> */}
          {/* </div> */}

          <Transition
            as={Fragment}
            enter="tw-transition tw-ease-out tw-duration-300"
            enterFrom="tw-opacity-0 tw-translate-y-1"
            enterTo="tw-opacity-100 tw-translate-y-0"
            leave="tw-transition tw-ease-in tw-duration-150"
            leaveFrom="tw-opacity-100 tw-translate-y-0"
            leaveTo="tw-opacity-0 tw-translate-y-1"
          >
            <Popover.Panel
              style={{ maxHeight: 'calc(75vh)' }}
              className={`tw-shadow-lg tw-ring-1 tw-ring-gray-200 tw-overflow-hidden?
              tw-absolute tw-overflow-y-auto tw-z-10 tw-inset-x-0 tw-mt-[13px] tw-transform
              tw-text-left`}
            >
              {/* <div className="tw-grid tw-grid-cols-1 lg:tw-grid-cols-2"> */}
              {/*  <code className={"tw-px-4 tw-py-8 tw-bg-white sm:tw-py-12 sm:tw-px-6 lg:tw-px-8 xl:tw-pr-12" +*/}
              {/*    " lg:tw-col-span-2 tw-bg-white"}> */}
              <Entities entities={data} />
              {/* </code> */}
              {/* </div> */}

              {false
                && (
                <div className="tw-inset-0 tw-max-w-7xl tw-mx-auto tw-grid tw-grid-cols-1 lg:tw-grid-cols-2">
                  <code className={'tw-px-4 tw-py-8 tw-bg-white sm:tw-py-12 sm:tw-px-6 lg:tw-px-8 xl:tw-pr-12'
                    + ' lg:tw-col-span-2 tw-bg-white'}
                  >
                    {JSON.stringify(data, null, ' ')}
                  </code>
                  <nav
                    className="tw-grid tw-gap-y-10 tw-px-4 tw-py-8 tw-bg-white sm:tw-grid-cols-2 sm:tw-gap-x-8
                    sm:tw-py-12 sm:tw-px-6 lg:tw-px-8 xl:tw-pr-12"
                    aria-labelledby="solutions-heading"
                  >
                    <h2 id="solutions-heading" className="tw-sr-only">
                      Solutions menu
                    </h2>
                    <div>
                      <h3
                        className="tw-text-sm tw-font-medium tw-tracking-wide tw-text-gray-500 tw-uppercase"
                      >
                        Company

                      </h3>
                      <ul role="list" className="tw-mt-5 tw-space-y-6">
                        {company.map((item) => (
                          <li key={item.name} className="tw-flow-root">
                            <a
                              href={item.href}
                              className="-tw-m-3 tw-p-3 tw-flex tw-items-center tw-rounded-md tw-text-base
                              tw-font-medium tw-text-gray-900 hover:tw-bg-gray-50 tw-transition tw-ease-in-out
                              tw-duration-150"
                            >
                              <item.icon
                                className="tw-flex-shrink-0 tw-h-6 tw-w-6 tw-text-gray-400"
                                aria-hidden="true"
                              />
                              <span className="tw-ml-4">{item.name}</span>
                            </a>
                          </li>
                        ))}
                      </ul>
                    </div>
                    <div>
                      <h3
                        className="tw-text-sm tw-font-medium tw-tracking-wide tw-text-gray-500 tw-uppercase"
                      >
                        Resources

                      </h3>
                      <ul role="list" className="tw-mt-5 tw-space-y-6">
                        {resources.map((item) => (
                          <li key={item.name} className="tw-flow-root">
                            <a
                              href={item.href}
                              className="-tw-m-3 tw-p-3 tw-flex tw-items-center tw-rounded-md tw-text-base
                              tw-font-medium tw-text-gray-900 hover:tw-bg-gray-50 tw-transition tw-ease-in-out
                              tw-duration-150"
                            >
                              <item.icon
                                className="tw-flex-shrink-0 tw-h-6 tw-w-6 tw-text-gray-400"
                                aria-hidden="true"
                              />
                              <span className="tw-ml-4">{item.name}</span>
                            </a>
                          </li>
                        ))}
                      </ul>
                    </div>
                  </nav>
                  <div className="tw-bg-gray-50 tw-px-4 tw-py-8 sm:tw-py-12 sm:tw-px-6 lg:tw-px-8 xl:tw-pl-12">
                    <div>
                      <h3 className="tw-text-sm tw-font-medium tw-tracking-wide tw-text-gray-500 tw-uppercase">
                        From the
                        blog

                      </h3>
                      <ul role="list" className="tw-mt-6 tw-space-y-6">
                        {blogPosts.map((post) => (
                          <li key={post.id} className="tw-flow-root">
                            <a
                              href={post.href}
                              className="-tw-m-3 tw-p-3 tw-flex tw-rounded-lg hover:tw-bg-gray-100 tw-transition
                              tw-ease-in-out tw-duration-150"
                            >
                              <div className="tw-hidden sm:tw-block tw-flex-shrink-0">
                                <img
                  className="tw-w-32 tw-h-20 tw-object-cover tw-rounded-md"
                  src={post.imageUrl}
                  alt=""
                />
                              </div>
                              <div className="tw-min-w-0 tw-flex-1 sm:tw-ml-8">
                                <h4
                  className="tw-text-base tw-font-medium tw-text-gray-900 tw-truncate"
                >
                  {post.name}

                </h4>
                                <p className="tw-mt-1 tw-text-sm tw-text-gray-500">{post.preview}</p>
                              </div>
                            </a>
                          </li>
                        ))}
                      </ul>
                    </div>
                    <div className="tw-mt-6 tw-text-sm tw-font-medium">
                      <a
                        href="#"
                        className="tw-text-indigo-600 hover:tw-text-indigo-500 tw-transition tw-ease-in-out
                      tw-duration-150"
                      >
                        View all posts
                        {' '}
                        <span aria-hidden="true">&rarr;</span>
                      </a>
                    </div>
                  </div>
                </div>
                )}
            </Popover.Panel>
          </Transition>
        </>
      )}
    </Popover>
  );
}
