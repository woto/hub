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
      pathLength: { duration: 10, bounce: 0 },
    },
  },
};

export default function Toast(props: {
  children: React.ReactNode,
  remove: (id: number) => void,
  id: number,
}) {
  const controls = useAnimationControls();

  useEffect(() => {
    controls.start('visible');
  }, [controls]);

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      layout
      onMouseEnter={() => {
        controls.stop();
      }}
      onMouseLeave={() => {
        controls.start('visible');
      }}
      className="tw-max-w-sm tw-w-full tw-bg-white tw-shadow-lg tw-rounded-lg tw-pointer-events-auto tw-ring-1 tw-ring-black tw-ring-opacity-5 tw-overflow-hidden"
    >
      <div className="tw-p-4">
        <div className="tw-flex tw-items-center">
          {props.children}

          <div className="tw-ml-4 tw-relative tw-p-1 tw-flex-shrink-0 tw-flex">
            <button
              type="button"
              className="tw-bg-white tw-rounded-full tw-inline-flex tw-text-gray-400 hover:tw-text-gray-500 focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-500"
              onClick={() => {
                props.remove(props.id);
              }}
            >
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
                  onAnimationComplete={() => props.remove(props.id)}
                  className="tw-stroke-2 tw-stroke-sky-300 tw-fill-transparent"
                  cx="20"
                  cy="20"
                  r="10"
                  initial="hidden"
                  animate={controls}
                  variants={draw}
                />
              </svg>

              <XMarkIcon className="tw-h-5 tw-w-5" aria-hidden="true" />
            </button>
          </div>
        </div>
      </div>
    </motion.div>
  );
}
