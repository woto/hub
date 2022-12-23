import * as React from 'react';
import { FireIcon, FlagIcon, StarIcon } from '@heroicons/react/24/outline';
import { Popover } from '@headlessui/react';
import { ReferenceType } from '@floating-ui/react-dom';
import { EyeIcon, PencilIcon, QueueListIcon } from '@heroicons/react/20/solid';
import { useState } from 'react';
import openEditEntity from '../system/Utility';
import OldBookmark from '../OldBookmark/OldBookmark';
import DynamicStarIcon from '../DynamicStarIcon';
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
      {false
        && (
        <OldBookmark
          foo={(reference: (node: ReferenceType) => void) => (
            <Popover.Button
              ref={reference}
              className={`
                ${true ? 'tw-z-50 tw-text-gray-900' : 'z-30 tw-text-gray-500'}
                tw-group tw-rounded tw-inline-flex tw-items-center tw-text-base
                tw-font-medium hover:tw-text-gray-700 focus:tw-outline-none
                focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-gray-500
                tw-flex tw-py-2.5 tw-items-center tw-justify-center tw-w-full tw-border tw-h-full
              `}
            >

              {true
              && (
              <>
                <FireIcon
                  className={`
                      ${true ? 'tw-text-gray-800' : 'tw-text-gray-500'}
                      ${true ? 'tw-bg-red-400' : ''}
                      tw-h-6 tw-w-6 group-hover:tw-text-gray-600 tw-mr-1
                    `}
                  aria-hidden="true"
                />
                Избр.
              </>
              )}
            </Popover.Button>
          )}
          ext_id=""
          favorites_items_kind=""
          is_checked={false}
        />
        )}

      {false
        && (
        <OldBookmark
          foo={(reference: (node: ReferenceType) => void) => (
            <Popover.Button
              ref={reference}
              className="tw-border-t tw-border-r tw-border-r-transparent tw-rounded-bl-2xl
      tw-select-none tw-basis-full tw-justify-center tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-3
      tw-border-slate-200 tw-bg-gradient-to-b tw-from-gray-50 tw-to-slate-100 tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-900
      hover:tw-to-slate-50 focus:tw-z-10 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300"
            >
              <DynamicStarIcon
                className="tw-h-4 tw-w-4 group-hover:tw-text-gray-600 tw-mr-1"
                isChecked
              />
              <div>Репорт</div>
            </Popover.Button>

            // tw-group tw-rounded tw-inline-flex tw-items-center tw-text-base
            // tw-font-medium hover:tw-text-gray-700 focus:tw-outline-none
            // focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-gray-500
            // tw-flex tw-py-2.5 tw-items-center tw-justify-center tw-w-full tw-border tw-h-full
          )}
          ext_id=""
          favorites_items_kind=""
          is_checked={false}
        />
        )}

      {false
        && (
        <button
          type="button"
          className="tw-rounded-bl-2xl tw-border-t tw-border-r tw-border-r-transparent
      tw-select-none tw-basis-full tw-justify-center tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-3
      tw-border-slate-200 tw-bg-gradient-to-b tw-from-gray-50 tw-to-slate-100 tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-900
      hover:tw-to-slate-50 focus:tw-z-10 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300"
        >
          <StarIcon className="tw-h-4 tw-mr-2" />
          <div>След.</div>
        </button>
        )}

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
        href={data?.link}
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
