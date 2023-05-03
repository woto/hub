import * as React from 'react';
import {
  AdjustmentsVerticalIcon, EllipsisVerticalIcon, PlusCircleIcon, PlusIcon, MinusIcon,
} from '@heroicons/react/24/outline';

export default function Entity(props: {
  entity: any, dispatchEntities: any, selected: boolean, close
}) {
  const {
    entity, dispatchEntities, selected, close,
  } = props;

  return (
    <>
      {/* {JSON.stringify(entity, null, ' ')} */}

      <div
        key={entity.entity_id}
        className="tw-relative tw-rounded-lg tw-border tw-border-gray-200 tw-bg-white/60 tw-px-4 tw-py-5
        tw-flex tw-items-center tw-space-x-3 hover:tw-shadow? focus-within:tw-ring-2?
        focus-within:tw-ring-offset-2? focus-within:tw-ring-indigo-500?"
      >
        <div className="tw-bg-slate-300? tw-flex-1 tw-min-w-0">
          <button
            type="button"
            className="tw-outline-indigo-500 tw-outline-offset-2
             tw-p-1 tw-text-left tw-max-w-full tw-group tw-flex tw-flex-1 tw-min-w-0 tw-items-center"
            onClick={() => window.location.assign(`/entities/${entity.entity_id}`)}
          >
            { entity.images && entity.images.length > 0
              && (
              <div className="tw-flex-shrink-0 tw-mr-3">
                <img
                  className="tw-opacity-80 group-hover:tw-opacity-100 tw-h-10 tw-w-10 tw-rounded tw-border tw-border-slate-200  tw-p-px tw-object-scale-down"
                  src={entity.images[0].image_url}
                  alt=""
                  loading="lazy"
                />
              </div>
              )}
            <div className="tw-flex-1 tw-min-w-0">
              <p className="tw-text-sm tw-font-medium tw-text-gray-700 group-hover:tw-text-black">
                {entity.title}
                <span className="tw-ml-2 tw-text-xs tw-text-gray-400">
                  {entity.count}
                  {' '}
                  /
                  {' '}
                  {entity.entities_mentions_count}
                </span>
              </p>
              <p className="tw-text-sm tw-text-gray-500 group-hover:tw-text-gray-900 tw-truncate">{entity.intro}</p>
            </div>
          </button>
        </div>
        { selected
          ? (
            <button
              type="button"
              className="tw-w-10 tw-h-10 tw-inline-flex tw-items-center tw-justify-center tw-text-gray-400
                        tw-rounded-full hover:tw-text-gray-500 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2
                      focus:tw-ring-indigo-500 tw-bg-slate-100 hover:tw-bg-slate-200"
              onClick={() => {
                close();
                dispatchEntities({ type: 'remove_entity', payload: entity });
              }}
            >
              <MinusIcon className="tw-w-7 tw-h-7" aria-hidden="true" />
            </button>
          )
          : (
            <button
              type="button"
              className="tw-w-10 tw-h-10 tw-inline-flex tw-items-center tw-justify-center tw-text-gray-400
                         tw-rounded-full hover:tw-text-gray-500 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2
                        focus:tw-ring-indigo-500 tw-bg-slate-100 hover:tw-bg-slate-200"
              onClick={() => {
                close();
                dispatchEntities({ type: 'append_entity', payload: entity });
              }}
            >
              <PlusIcon className="tw-w-7 tw-h-7" aria-hidden="true" />
            </button>
          )}
      </div>
    </>
  );
}
