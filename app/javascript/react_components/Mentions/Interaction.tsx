import * as React from 'react';
import {
  ChatBubbleBottomCenterTextIcon,
  FlagIcon,
  HandThumbDownIcon,
  HandThumbUpIcon,
  ShareIcon,
} from '@heroicons/react/24/outline';
import { Menu } from '@headlessui/react';
import { ChevronDownIcon } from '@heroicons/react/24/solid';
import { useState } from 'react';
import Comments from './Comments';
import Share from './Share';
import Complain from '../Complain';

export default function Interaction({ mention, entities }: {mention: any, entities: any[]}) {
  const [commentsOpen, setCommentsOpen] = useState(false);
  const [isComplainOpen, setIsComplainOpen] = useState(false);

  return (
    <>
      <div className="tw-relative tw-flex-shrink tw-flex tw-flex-col tw-justify-center tw-inset-y-0">
        <span
          className="tw-absolute tw-z-10 tw-right-3 tw-flex tw-flex-col tw-items-center tw-justify-center
        ? tw-rounded-full -tw-space-y-px tw-border-stone-100? tw-border?"
        >

          <div className="tw-absolute tw-inset-2 tw-bg-black/20 tw-rounded-full tw-blur" />

          <button
            type="button"
            className="tw-rounded-t-full tw-border tw-group
                focus:tw-z-10 tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-4
                tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-700
                focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300 focus:tw-border-indigo-300
                tw-border-gray-200/80 tw-bg-gradient-to-r tw-from-slate-50 tw-to-slate-100"
          >
            <HandThumbUpIcon className="group-hover:tw-animate-wiggle tw-w-6 tw-h-6" />
          </button>

          <button
            type="button"
            className="tw-border tw-group
                focus:tw-z-10 tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-4
                tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-700
                focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300 focus:tw-border-indigo-300
                tw-border-gray-200/80 tw-bg-gradient-to-r tw-from-slate-50 tw-to-slate-100"
            onClick={() => {
              setIsComplainOpen(true);
            }}
          >
            <FlagIcon className="group-hover:tw-animate-wiggle tw-w-6 tw-h-6" />
          </button>

          <button
            type="button"
            className="tw-border
                focus:tw-z-10 tw-relative tw-inline-flex tw-items-center tw-px-4 tw-py-4
                tw-text-sm tw-font-medium tw-text-gray-500 hover:tw-text-gray-700
                focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-indigo-300 focus:tw-border-indigo-300
                tw-border-gray-200/80 tw-bg-gradient-to-r tw-from-slate-50 tw-to-slate-100"
            onClick={() => setCommentsOpen(true)}
          >
            <ChatBubbleBottomCenterTextIcon className="group-hover:tw-animate-wiggle tw-w-6 tw-h-6" />
          </button>

          <Comments open={commentsOpen} setOpen={setCommentsOpen} />

          <Share mention={mention} entities={entities} />

        </span>
      </div>

      <Complain
        mentionId={mention.id}
        opened={isComplainOpen}
        close={() => {
          setIsComplainOpen(false);
        }}
      />

    </>
  );
}
