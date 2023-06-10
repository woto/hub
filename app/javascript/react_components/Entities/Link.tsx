import * as React from 'react';
import { useRef, useState } from 'react';
import {
  useFloating,
  useHover,
  useInteractions,
  offset,
  autoUpdate,
  FloatingArrow,
  arrow,
  autoPlacement,
} from '@floating-ui/react';

export default function EntitiesLink(
  props: {
    link: string
  },
) {
  const { link } = props;
  const [isOpen, setIsOpen] = useState(false);
  const arrowRef = useRef(null);
  const {
    x, y, strategy, refs, context,
  } = useFloating({
    // placement: 'right',
    open: isOpen,
    onOpenChange: setIsOpen,
    whileElementsMounted: autoUpdate,
    middleware: [
      offset(10),
      // autoPlacement(),
      arrow({
        element: arrowRef,
      }),
    ],
  });

  const hover = useHover(context, {
    delay: {
      open: 200,
      close: 0,
    },
  });

  const { getReferenceProps, getFloatingProps } = useInteractions([hover]);

  return (
    <li className="tw-relative">
      <div className="tw-group tw-block tw-w-full [aspect-ratio:10_/_7] tw-rounded-lg tw-bg-gray-100 focus-within:tw-ring-2 focus-within:tw-ring-offset-2 focus-within:tw-ring-offset-gray-100 focus-within:tw-ring-indigo-500 tw-overflow-hidden">
        <img src="https://fakeimg.pl/400x280/" alt="" className="tw-object-cover tw-pointer-events-none group-hover:tw-opacity-75" />
        <a
          href={link}
          ref={refs.setReference}
          {...getReferenceProps()}
          type="button"
          className="tw-absolute tw-inset-0 focus:tw-outline-none"
        >
          {/* <span className="tw-sr-only"></span> */}

          {isOpen && (
            <div
              className="tw-z-50 tw-bg-gray-800 tw-text-gray-50 tw-rounded tw-p-2 tw-w-96? tw-text-sm tw-max-w-sm tw-break-words"
              ref={refs.setFloating}
              style={{
                position: strategy,
                top: y ?? 0,
                left: x ?? 0,
              }}
              {...getFloatingProps()}
            >
              <FloatingArrow ref={arrowRef} context={context} />
              {link}
            </div>
          )}
        </a>
      </div>
      <div className="tw-mt-2 tw-block tw-text-sm tw-font-medium tw-text-gray-900 tw-truncate tw-pointer-events-none">
        <div className="tw-relative">
          <div className="tw-truncate">
            {link}
          </div>
        </div>
      </div>
    </li>
  );
}
