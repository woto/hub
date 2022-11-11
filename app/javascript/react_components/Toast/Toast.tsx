import React, { MouseEventHandler, useEffect } from 'react';
/* This example requires Tailwind CSS v2.0+ */
import { Fragment, useState } from 'react';
import { Transition } from '@headlessui/react';
import {
  AnimatePresence, motion, useAnimation, useAnimationControls,
} from 'framer-motion';
import { XMarkIcon } from '@heroicons/react/24/solid';

const draw = {
  hidden: { pathLength: 0, opacity: 0 },
  visible: {
    pathLength: 1,
    opacity: 1,
    transition: {
      opacity: { duration: 1 },
      pathLength: { duration: 5, bounce: 0 },
    },
  },
};

export default function Toast(props: {
  children: React.ReactNode,
  onDismiss: MouseEventHandler<HTMLDivElement> | undefined
}) {
  const [show, setShow] = useState(true);
  const [showCircle, setShowCircle] = useState(false);

  const controls = useAnimationControls();

  useEffect(() => {
    controls.start('visible');
  }, [showCircle]);

  return (
    <Transition
      afterEnter={() => { setShowCircle(true); }}
      appear
      show={show}
      as={Fragment}
      enter="tw-transform tw-ease-out tw-duration-300 tw-transition"
      enterFrom="tw-translate-y-2 tw-opacity-0 sm:tw-translate-y-0 sm:tw-translate-x-2"
      enterTo="tw-translate-y-0 tw-opacity-100 sm:tw-translate-x-0"
      leave="tw-transition tw-ease-in tw-duration-100"
      leaveFrom="tw-opacity-100"
      leaveTo="tw-opacity-0"
    >
      <div
        onMouseEnter={() => { controls.stop(); }}
        onMouseLeave={() => { controls.start('visible'); }}
        className="tw-max-w-sm tw-w-full tw-bg-white tw-shadow-lg tw-rounded-lg tw-pointer-events-auto
          tw-ring-1 tw-ring-black tw-ring-opacity-5 tw-overflow-hidden"
      >
        <div className="tw-p-4">
          <div className="tw-flex tw-items-center">

            {props.children}

            <div className="tw-ml-4 tw-relative tw-p-1 tw-flex-shrink-0 tw-flex">
              <button
                className="tw-bg-white tw-rounded-full tw-inline-flex tw-text-gray-400 hover:tw-text-gray-500
                focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
                onClick={() => {
                  setShow(false);
                }}
              >

                <AnimatePresence>
                  {showCircle
                    && (
                    <svg
                      className="tw-h-16 tw-w-16 tw-absolute tw-left-1/2 -tw-translate-x-1/2 tw-top-1/2 -tw-translate-y-1/2"
                      viewBox="0 0 40 40"
                    >
                      <circle
                        className="tw-stroke-2 tw-stroke-sky-50 tw-fill-transparent"
                        cx="20"
                        cy="20"
                        r="10"
                      />

                      <motion.circle
                        onAnimationComplete={() => setShow(false)}
                        className="tw-stroke-2 tw-stroke-sky-300 tw-fill-transparent"
                        cx="20"
                        cy="20"
                        r="10"
                        initial="hidden"
                        animate={controls}
                        variants={draw}
                      />
                    </svg>
                    )}
                </AnimatePresence>

                <XMarkIcon className="tw-h-5 tw-w-5" aria-hidden="true" />

              </button>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  );
}
