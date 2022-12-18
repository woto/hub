import { ArrowPathIcon } from '@heroicons/react/24/outline';
import * as React from 'react';

function Searching() {
  return (
    <div className="tw-py-14 tw-px-6 tw-text-center tw-text-sm sm:tw-px-14 tw-grow">
      <ArrowPathIcon className="tw-mx-auto tw-h-6 tw-w-6 tw-text-gray-400" aria-hidden="true" />
      <p className="tw-mt-4 tw-font-semibold tw-text-gray-900">Идёт поиск</p>
      <p className="tw-mt-2 tw-text-gray-500">Пожалуйста ожидайте...</p>
    </div>
  );
}

export default React.memo(Searching);
