import * as React from 'react';

export default function AddEntity() {
  return (
    <div className="mt-1">
      <input
        type="text"
        className=" focus:tw-ring-indigo-300 focus:tw-border-indigo-300
          tw-block tw-w-full sm:tw-text-sm tw-border-gray-300 tw-px-4 tw-rounded-full"
        placeholder="Введите строку для поиска..."
      />
    </div>
  );
}
