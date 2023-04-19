import * as React from 'react';
import { FireIcon, FlagIcon, StarIcon } from '@heroicons/react/24/outline';
import { Popover } from '@headlessui/react';
import { ReferenceType } from '@floating-ui/react-dom';
import { EyeIcon, PencilIcon, QueueListIcon } from '@heroicons/react/20/solid';
import { useState } from 'react';
import openEditEntity from '../system/Utility';
import Complain from '../Complain';
import { useToasts } from '../Toast/ToastManager';
import ListingsIndex from '../Listings/ListingsIndex';

export default function PopupButtons({
  data,
  setIsPopupOpen,
  setIsListingsOpen,
  setIsComplainOpen,
}: {
    data: any,
     setIsPopupOpen: React.Dispatch<React.SetStateAction<boolean>>,
     setIsListingsOpen: React.Dispatch<React.SetStateAction<boolean>>,
     setIsComplainOpen: React.Dispatch<React.SetStateAction<boolean>>
}) {
  const { add } = useToasts();

  return (
    <div className="tw-relative tw-z-0 tw-inline-flex tw-shadow-sm? tw-rounded-b-2xl tw-w-full">
      <button
        type="button"
        onClick={() => {
          setTimeout(() => { setIsComplainOpen(true); }, 300);
          setIsPopupOpen(false);
        }}
        className="tw-rounded-bl-2xl tw-border-t tw-border-r tw-border-r-transparent
        tw-select-none tw-basis-full tw-justify-center tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-3
        tw-border-slate-200 tw-bg-gradient-to-b tw-from-gray-50 tw-to-slate-100 tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-900
        hover:tw-to-slate-50 focus:tw-z-10 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300"
      >
        <FlagIcon className="tw-h-4 tw-w-4 tw-mr-2?" />
      </button>

      <a
        href={data?.entity_url}
        className="-tw-ml-px tw-border-l tw-border-t tw-border-r tw-border-r-transparent
        tw-select-none tw-basis-full tw-justify-center tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-3
        tw-border-slate-200 tw-bg-gradient-to-b tw-from-gray-50 tw-to-slate-100 tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-900
        hover:tw-to-slate-50 focus:tw-z-10 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300"
      >
        <EyeIcon className="tw-h-4 tw-w-4 tw-mr-2" />
        <div className="text-xs">просм.</div>
      </a>

      <button
        type="button"
        onClick={() => {
          setTimeout(() => { setIsListingsOpen(true); }, 300);
          setIsPopupOpen(false);
        }}
        className="-tw-ml-px tw-border-l tw-border-t tw-border-r tw-border-r-transparent
        tw-select-none tw-basis-full tw-justify-center tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-3
        tw-border-slate-200 tw-bg-gradient-to-b tw-from-gray-50 tw-to-slate-100 tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-900
        hover:tw-to-slate-50 focus:tw-z-10 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300"
      >
        <QueueListIcon className="tw-h-4 tw-w-4 tw-mr-2" />
        <div className="text-xs">кол.</div>
      </button>

      <button
        onClick={() => {
          try {
            openEditEntity(data?.entity_id);
          } catch (error) {
            add('Расширение Chrome не ответило вовремя. Проверьте, что оно установлено.');
          }
        }}
        type="button"
        className="tw-rounded-br-2xl -tw-ml-px tw-border-l tw-border-t tw-border-r tw-border-r-transparent
        tw-select-none tw-basis-full tw-justify-center tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-3
        tw-border-slate-200 tw-bg-gradient-to-b tw-from-gray-50 tw-to-slate-100 tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-900
        hover:tw-to-slate-50 focus:tw-z-10 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300"
      >
        <PencilIcon className="tw-h-4 tw-w-4 tw-mr-2" />
        <div className="text-xs">ред.</div>
      </button>
    </div>
  );
}
