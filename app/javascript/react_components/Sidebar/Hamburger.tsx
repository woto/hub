import { HomeIcon } from '@heroicons/react/20/solid';
import { Bars3Icon } from '@heroicons/react/24/outline';
import * as React from 'react';
import SidebarContext from './Context';
import { SidebarInterface } from '../system/TypeScript';

export default function Hamburger() {
  const sidebarContext = React.useContext<SidebarInterface>(SidebarContext);
  return (
    <div className="lg:tw-hidden">
      <div className="tw-flex tw-items-center tw-justify-between tw-bg-gray-50 tw-border-b tw-border-gray-200 tw-px-4 tw-py-1.5">
        <div>
          <img
            className="tw-h-8 tw-w-auto"
            src="/roastme-fire.svg"
            alt="RoastMe.ru (logo)"
          />
        </div>
        <div>
          <button
            type="button"
            className="-tw-mr-3 tw-h-12 tw-w-12 tw-inline-flex tw-items-center tw-justify-center tw-rounded-md tw-text-gray-500 hover:tw-text-gray-900"
            onClick={() => sidebarContext.setSidebarOpen(true)}
          >
            <span className="tw-sr-only">Open sidebar</span>
            <Bars3Icon className="tw-h-6 tw-w-6" aria-hidden="true" />
          </button>
        </div>
      </div>
    </div>
  );
}
