import { PencilIcon } from '@heroicons/react/24/solid';
import * as React from 'react';

export default function InplaceEditButton(props: {
  children: ReactNode,
  onEdit: () => void,
  selectedListing: any
}) {
  const { onEdit, selectedListing, children } = props;

  return (
    <div className="tw-text-gray-900">
      {children}
      { selectedListing?.is_owner
        && (
        <button
          onClick={onEdit}
          type="button"
          className="tw-ml-3 tw-align-bottom tw-p-1
              tw-border tw-border-transparent hover:tw-border-gray-300
              tw-font-medium tw-rounded-lg tw-text-gray-500 hover:tw-bg-gray-100 focus:tw-outline-none
              focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
        >
          <PencilIcon className="tw-w-4 tw-h-4" />
        </button>
        )}
    </div>
  );
}
