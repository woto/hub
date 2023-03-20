import { useState } from 'react';
import * as React from 'react';
import { Popover, Transition } from '@headlessui/react';
import { FireIcon } from '@heroicons/react/24/solid';
import {
  useQueryClient,
  QueryClient,
  QueryClientProvider, QueryErrorResetBoundary,
} from 'react-query';
import axios from '../system/Axios';

import {
  autoUpdate, flip, offset, shift, useFloating,
} from '@floating-ui/react-dom';
import List from './List';

function OldBookmark(props: { foo: any, ext_id: string, favorites_items_kind: string, is_checked: boolean }) {
  const {
    x, y, reference, floating, strategy,
  } = useFloating({
    whileElementsMounted: autoUpdate,
    middleware: [flip(), shift({ padding: 10 }), offset(5)],
  });

  const [items, setItems] = useState([]);

  return (
    <Popover className="tw-relative">
      {({ open, close }) => (
        <div className={`tw-relative ${open ? 'tw-z-30' : 'tw-z-20?'}`}>
          {false
            && (
            <Popover.Button
              ref={reference}
              className={`
                ${open ? 'tw-z-50 tw-text-gray-900' : 'z-30 tw-text-gray-500'}
                tw-group tw-rounded tw-inline-flex tw-items-center tw-text-base
                tw-font-medium hover:tw-text-gray-700 focus:tw-outline-none
                focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-gray-500
              `}
            >

              {true
                && (
                <>
                  <FireIcon
                    className={`
                      ${open ? 'tw-text-gray-800' : 'tw-text-gray-500'}
                      ${props.is_checked ? 'tw-bg-red-400' : ''}
                      tw-h-6 tw-w-6 group-hover:tw-text-gray-600 tw-mr-1
                    `}
                    aria-hidden="true"
                  />
                  Избранное
                </>
                )}
            </Popover.Button>
            )}

          {props.foo && props.foo(reference)}

          <div
            ref={floating}
            style={{
              position: strategy,
              top: y ?? 0,
              left: x ?? 0,
            }}
          >
            <Transition
              // appear={true}
              show={open}
              // as={Fragment}
              enter="tw-transition tw-ease-out tw-duration-200"
              enterFrom="tw-opacity-0 tw-translate-y-1"
              enterTo="tw-opacity-100 tw-translate-y-0"
              leave="tw-transition tw-ease-in tw-duration-150"
              leaveFrom="tw-opacity-100 tw-translate-y-0"
              leaveTo="tw-opacity-0 tw-translate-y-1"
            >
              <Popover.Panel
                className="tw-z-40 tw-transform tw-mt-3? tw-px-2 tw-w-screen tw-max-w-xs sm:tw-px-0"
              >
                <div
                  className="tw-rounded-lg  tw-ring-1 tw-ring-black tw-ring-opacity-5 tw-overflow-hidden"
                >
                  <div className="tw-relative tw-grid tw-gap-3 tw-bg-slate-50 tw-p-8">
                    List in the old Bookmark
                  </div>
                </div>
              </Popover.Panel>
            </Transition>
          </div>
        </div>
      )}
    </Popover>
  );
}

export default React.memo(OldBookmark);
