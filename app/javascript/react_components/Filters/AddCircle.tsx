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
import AddCircleContent from './AddCircleContent';

export default function AddCircle(props: {entityIds: number[], entityTitle: string, q: string}) {
  return (
    <Popover className="tw-z-0 tw-relative?">
      {({ open }) => (
        <>
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
              style={{ maxHeight: 'calc(85vh)' }}
              className={`tw-shadow-lg tw-ring-1 tw-ring-gray-200 tw-overflow-x-hidden
                tw-absolute tw-overflow-y-auto tw-z-10 tw-inset-x-0 tw-mt-[13px] tw-transform
                tw-text-left`}
            >
              <AddCircleContent
                entityIds={props.entityIds}
                entityTitle={props.entityTitle}
                q={props.q}
              />
            </Popover.Panel>
          </Transition>

        </>
      )}
    </Popover>
  );
}
