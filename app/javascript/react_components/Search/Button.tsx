import { MagnifyingGlassIcon } from '@heroicons/react/24/outline';
import * as React from 'react';
import { useState } from 'react';
import Modal from './Modal';

export default function Search() {
  const [signinModalOpen, setSigninModalOpen] = useState(false);

  return (
    <>
      <Modal
        open={signinModalOpen}
        setOpen={setSigninModalOpen}
      />

      <button
        type="button"
        className={`
        lg:tw-text-sm
        tw-bg-gray-100 lg:tw-bg-white
      tw-text-gray-500 hover:tw-text-gray-900 tw-cursor-text tw-w-full
        tw-group tw-flex tw-items-center tw-px-2 tw-py-3 lg:tw-py-2.5 tw-font-medium tw-rounded-md
        `}
        onClick={() => setSigninModalOpen(true)}
      >
        <MagnifyingGlassIcon
          className={`
            tw-text-gray-500 group-hover:tw-text-gray-900
            tw-mr-4 lg:tw-mr-3 tw-h-6 tw-w-6
          `}
          aria-hidden="true"
        />
        Поиск
      </button>

      { false && (
      <>
        <label htmlFor="search" className="tw-sr-only">
          Search
        </label>
        <div className="tw-relative tw-text-gray-400 focus-within:tw-text-gray-600">
          <div
            className="tw-pointer-events-none tw-absolute tw-inset-y-0 tw-left-0 tw-pl-2 tw-flex tw-items-center"
          >
            <MagnifyingGlassIcon className="tw-h-6 tw-w-6" aria-hidden="true" />
          </div>

          <input
            id="search"
            className={`
            tw-pl-12 lg:tw-pl-11
            tw-bg-gray-100 tw-py-3
            lg:tw-bg-white lg:tw-py-2
              tw-block tw-w-full tw-pr-3 tw-border tw-border-transparent
              tw-rounded-md tw-leading-5 tw-text-gray-900 tw-placeholder-gray-500 focus:tw-outline-none
              focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-offset-indigo-600 focus:tw-ring-white
              focus:tw-border-white lg:tw-text-sm tw-font-medium`}
            placeholder="Search"
            type="search"
            name="search"
            onClick={() => setSigninModalOpen(true)}
          />
        </div>

      </>
      )}
    </>
  );
}
