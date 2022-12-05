import * as React from 'react';
import {
  useCallback, useEffect, useRef, useState,
} from 'react';
import {
  motion,
  useMotionValue,
  useTransform,
  AnimatePresence,
  useDomEvent,
} from 'framer-motion';

import { ChevronDoubleLeftIcon, ChevronDoubleRightIcon } from '@heroicons/react/20/solid';
import Card from './Card';

export default function Tinder() {
  const [index, setIndex] = useState(0);

  // console.log(index);

  return (
    <>
      <div className="tw-bg-gray-300 sm:tw-rounded-t-lg pointer-events-none tw-w-full? tw-h-full?
                      tw-py-20 sm:tw-py-12 md:tw-py-16 lg:tw-py-24 xl:tw-py-32 tw-overflow-hidden
                      tw-flex tw-justify-center tw-items-center tw-select-none"
      >
        <motion.div
          data-test-id="tinder"
          style={{
            width: 300,
            height: 300,
            position: 'relative',
          }}
        >
          <AnimatePresence initial={false}>
            <Card
              useQueryKey={index + 1}
              key={index + 1}
              initial={{ scale: 0, y: 105, opacity: 0 }}
              animate={{ scale: 0.80, y: 50, opacity: 0.5 }}
              transition={{
                scale: { duration: 0.2 },
                opacity: { duration: 0.4 },
              }}
            />
            <Card
              useQueryKey={index}
              key={index}
              animate={{ scale: 1, y: 0, opacity: 1 }}
              transition={{
                type: 'spring',
                stiffness: 300,
                damping: 20,
                opacity: { duration: 0.2 },
              }}
              index={index}
              setIndex={setIndex}
              drag="x"
            />
          </AnimatePresence>
        </motion.div>
      </div>
      <div className="tw-flex tw-justify-center tw-items-center tw-text-slate-100
                      tw-select-none tw-py-5 tw-mx-auto tw-w-full tw-bg-gray-500 sm:tw-rounded-b-lg"
      >
        <ChevronDoubleLeftIcon className="tw-inline? tw-h-4 tw-w-4" />
        <div className="tw-px-4">
          Перетащите карточку
        </div>
        <ChevronDoubleRightIcon className="tw-inline? tw-h-4 tw-w-4" />
      </div>
    </>
  );
}
