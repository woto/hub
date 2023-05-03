import * as React from 'react';
import { MagnifyingGlassIcon } from '@heroicons/react/24/outline';
import { useState } from 'react';

export default function SearchMentions(props: {
  setScrollToFirst: React.Dispatch<React.SetStateAction<boolean>>,
  mentionsSearchString: string,
  setMentionsSearchString: React.Dispatch<React.SetStateAction<string>>
}) {
  const { mentionsSearchString, setMentionsSearchString, setScrollToFirst } = props;

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    e.stopPropagation();

    if (['Enter'].includes(e.key)) {
      e.preventDefault();
      setScrollToFirst(true);
      setMentionsSearchString(e.target.value);
      e.target.blur();
    }
  };

  return (
    <div
      className="tw-ml-auto tw-group tw-mr-3 tw-relative tw-border-b-transparent focus-within:tw-border-indigo-300"
    >
      <div className="tw-absolute tw-inset-y-0 tw-left-0 tw-flex tw-items-center tw-pointer-events-none">
        <MagnifyingGlassIcon
          className="tw-h-6 tw-w-6 tw-text-gray-400 group-hover:tw-text-gray-600"
          aria-hidden="true"
        />
      </div>
      <input
        type="text"
        className={`
        focus:tw-border-indigo-300
        ${mentionsSearchString
          ? 'tw-w-full tw-border-gray-300 tw-cursor-text'
          : 'tw-w-0 focus:tw-w-full tw-cursor-pointer'}
        focus:tw-cursor-text tw-pl-7 tw-pr-0 tw-block
        tw-border-0 tw-border-b-2 tw-border-transparent tw-bg-transparent
        focus:tw-ring-0 sm:tw-text-sm`}
        value={mentionsSearchString}
        onChange={(e) => {
          setMentionsSearchString(e.target.value);
        }}
        onKeyDown={handleKeyDown}
        placeholder="Поиск"
      />
    </div>
  );
}
