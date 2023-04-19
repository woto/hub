import * as React from 'react';
import { Dispatch, SetStateAction, useState } from 'react';
import {
  animate,
  motion,
  useMotionValue,
  useScroll,
  useSpring,
  AnimatePresence,
  LayoutGroup,
} from 'framer-motion';
import { useQuery } from '@tanstack/react-query';
import { ArrowPathIcon, StarIcon } from '@heroicons/react/24/outline';
import axios from '../system/Axios';
import { CarouselType, DOMRectJSON } from '../system/TypeScript';
import SingleTag from '../Tags/Single';
import PopupButtons from './PopupButtons';
import Multiple from '../Tags/Multiple';

export default function Popup({
  selectedItem,
  setIsPopupOpen,
  setIsListingsOpen,
  setIsComplainOpen,
}: {
  selectedItem: any
  setIsPopupOpen: React.Dispatch<React.SetStateAction<boolean>>,
  setIsListingsOpen: React.Dispatch<React.SetStateAction<boolean>>,
  setIsComplainOpen: React.Dispatch<React.SetStateAction<boolean>>
}) {
  const {
    isLoading, error, data, isFetching,
  } = useQuery(['popup', selectedItem?.entity_id], () => {
    if (selectedItem?.id) {
      return axios
        .get(`/api/entities/${selectedItem?.entity_id}`)
        .then((res) => res.data);
    }
  });

  return (
    isLoading
      ? (
        <div className="tw-h-full tw-w-full tw-flex tw-items-center tw-justify-center tw-min-h-[inherit] tw-max-h-[inherit]">
          <ArrowPathIcon className="tw-animate-spin tw-h-5 tw-w-5 tw-text-blue-500" />
        </div>
      )
      : (
        <div
          className="tw-w-full tw-flex tw-flex-col tw-items-center tw-justify-between tw-min-h-[inherit] tw-max-h-[inherit] tw-h-px?"
        >
          <div
            className="tw-m-1.5 tw-flex tw-flex-col tw-min-h-[inherit]? tw-h-full tw-grow tw-h-px? tw-overflow-y-auto"
            onClick={() => setIsPopupOpen(false)}
          >
            <div className="tw-space-y-6 tw-min-h-[inherit] tw-h-full tw-max-h-[inherit]">
              { data && data.title && (
              <div
                className="tw-select-none tw-pt-6 tw-text-gray-900 tw-px-4 tw-font-medium tw-text-center tw-text-base"
              >
                <a href={data?.link}>
                  {data.title}
                </a>
              </div>
              )}

              {false && data && data.images && data.images.length > 0 && (
              <div className="tw-mx-1">
                <img
                            // layoutId={`image-${selectedItem?.id}`}
                            // key={`image-${selectedItem?.id}`}
                            // layout
                  alt=""
                  className="tw-border tw-h-auto tw-rounded-md tw-object-contain tw-pointer-events-none tw-select-none"
                  src={selectedItem.images[0].images['500']}
                />
              </div>
              )}

              {data && data.kinds && data.kinds.length > 0 && (
              <div className="tw-px-4 tw-select-none tw-items-baseline?">
                <Multiple tags={data.kinds} limit={10} textColor="tw-text-blue-800" bgColor="tw-bg-blue-100" linkify={false} />
              </div>
              )}

              {data && data.intro && (
              <div
                className="tw-select-none tw-pb-6 tw-px-4
                tw-text-gray-700 tw-text-sm tw-text-left tw-leading-6"
              >
                {data.intro}

              </div>
              )}

            </div>
          </div>

          <div className="tw-w-full">
            <PopupButtons
              data={data}
              setIsPopupOpen={setIsPopupOpen}
              setIsComplainOpen={setIsComplainOpen}
              setIsListingsOpen={setIsListingsOpen}
            />
          </div>

        </div>
      )
  );
}

// export default React.forwardRef(Popup)
