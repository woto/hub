import { SparklesIcon } from '@heroicons/react/24/outline';
import * as React from 'react';

export default function Tinder() {
  return (
    <a
      className="tw-w-full lg:tw-text-sm tw-text-gray-500 hover:tw-text-gray-700
                      tw-group tw-flex tw-items-center tw-px-2 tw-py-2 tw-text-base tw-font-medium
                      tw-rounded-md"
      data-turbo="false"
      href="/tinder"
    >
      <SparklesIcon
        className={`
            tw-text-gray-500 group-hover:tw-text-gray-900
            tw-mr-4 lg:tw-mr-3 tw-h-6 tw-w-6
          `}
        aria-hidden="true"
      />
      Tinder
    </a>
  );
}
