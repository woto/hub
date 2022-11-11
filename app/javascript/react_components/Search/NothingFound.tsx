import { FaceFrownIcon } from '@heroicons/react/24/outline';
import * as React from 'react';

function NothingFound() {
  return (
    <div className="tw-py-14 tw-px-6 tw-text-center tw-text-sm sm:tw-px-14">
      <FaceFrownIcon className="tw-mx-auto tw-h-6 tw-w-6 tw-text-gray-400" aria-hidden="true" />
      <p className="tw-mt-4 tw-font-semibold tw-text-gray-900">Ничего не найдено</p>
      <p className="tw-mt-2 tw-text-gray-500">Попробуйте изменить поисковый запрос.</p>
    </div>
  );
}

export default React.memo(NothingFound);
