import * as React from 'react';
import { AdjustmentsVerticalIcon, EllipsisVerticalIcon, PlusCircleIcon, PlusIcon } from '@heroicons/react/24/outline';

export default function Entity(props: { entity: any }) {
  return (
    <>
      {/* {JSON.stringify(props.entity, null, ' ')} */}

      <div
        key={props.entity.entity_id}
        className="tw-relative tw-rounded-lg tw-border tw-border-gray-200 tw-bg-white/60 tw-px-6 tw-py-5
        tw-flex tw-items-center tw-space-x-3 hover:tw-border-gray-300 focus-within:tw-ring-2?
        focus-within:tw-ring-offset-2? focus-within:tw-ring-indigo-500?"
      >
        { props.entity.images && props.entity.images.length > 0
          && (
          <div className="tw-flex-shrink-0">
            <img
              className="tw-h-10 tw-w-10 tw-rounded tw-border tw-border-slate-200  tw-p-px tw-object-scale-down"
              src={props.entity.images[0].image_url}
              alt=""
            />
          </div>
          )}
        <div className="tw-flex-1 tw-min-w-0">
          <button
            type="button"
            className="focus:tw-outline-none tw-text-left tw-max-w-full tw-group"
            onClick={() => window.location.assign(`/entities/${props.entity.entity_id}`)}
          >
            {/* <span className="tw-absolute tw-inset-0" aria-hidden="true" /> */}
            <p className="tw-text-sm tw-font-medium tw-text-gray-700 group-hover:tw-text-gray-900">{props.entity.title}</p>
            <p className="tw-text-sm tw-text-gray-500 group-hover:tw-text-gray-700 tw-truncate">{props.entity.intro}</p>
          </button>
        </div>
        <button
          type="button"
          className="tw-w-10 tw-h-10 tw-inline-flex tw-items-center tw-justify-center tw-text-gray-400
          tw-rounded-full hover:tw-text-gray-500 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2
          focus:tw-ring-indigo-500 tw-bg-slate-100 hover:tw-bg-slate-200"
          onClick={() => {}}
        >
          <span className="tw-sr-only">Open options</span>
          <PlusIcon className="tw-w-7 tw-h-7" aria-hidden="true" />
        </button>
      </div>
    </>
  );
}
