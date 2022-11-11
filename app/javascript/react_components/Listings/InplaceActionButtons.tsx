import * as React from 'react';
import { ReactNode } from 'react';

export default function InplaceActionButtons(props: {
  children: ReactNode,
  onCancelEdit: () => void,
  onSave: () => void,
  selectedListing: any
}) {
  const {
    selectedListing, onCancelEdit, onSave, children,
  } = props;

  return (
    <div className="tw-w-full">
      {children}

      {selectedListing?.id
        && (
        <div className="tw-mt-3 tw-text-sm tw-gap-3 tw-flex">
          <button
            onClick={onSave}
            className="tw-text-indigo-500 hover:tw-text-indigo-900"
            type="button"
          >
            Сохранить
          </button>

          <button
            onClick={onCancelEdit}
            className="tw-text-gray-500 hover:tw-text-gray-900"
            type="button"
          >
            Отмена
          </button>
        </div>
        )}
    </div>
  );
}
