import * as React from 'react';
import {
  useEffect, useLayoutEffect, useRef, useState,
} from 'react';
import {
  motion,
  useMotionValue,
  useTransform,
  AnimatePresence,
  useDomEvent,
  useSpring,
} from 'framer-motion';
import { useQuery } from 'react-query';
import axios from '../system/Axios';

import SingleTag from '../Tags/Single';
import Multiple from '../Tags/Multiple';

export default function Card(props) {
  const x = useMotionValue(0);
  const scale = useTransform(x, [-300, 0, 300], [0.5, 1, 0.5]);
  const rotate = useTransform(x, [-300, 0, 300], [-45, 0, 45], {
    clamp: false,
  });

  // const [testNumber, setTestNumber] = useState<number>();

  const {
    isLoading, error, data, isFetching,
  } = useQuery(`card:${props.useQueryKey}`, () => axios
    .get('/api/entities/random')
    .then((res) => res.data));

  const [exitX, setExitX] = useState<number>(0);

  function handleDragEnd(event, info) {
    if (info.offset.x < -100) {
      setExitX(-300);
      props.setIndex(props.index + 1);
    }
    if (info.offset.x > 100) {
      setExitX(300);
      props.setIndex(props.index + 1);
    }
  }

  return (
    <motion.div
      data-test-class="card"
      data-entity-id={data?.entity_id ?? ''}
      style={{
        width: 300,
        height: 300,
        position: 'absolute',
        top: 0,
        x,
        rotate,
        cursor: 'grab',
      }}
      whileTap={{ cursor: 'grabbing' }}
      drag={props.drag}
      dragConstraints={{
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
      }}
      onDragEnd={handleDragEnd}
      initial={props.initial}
      animate={props.animate}
      transition={props.transition}
      exit={{
        x: exitX,
        opacity: 0,
        scale: 0.5,
        transition: { duration: 0.2 },
      }}
    >
      <motion.div
        className="tw-bg-white tw-p-4 tw-border-4 tw-border-indigo-500 tw-flex tw-flex-col tw-rounded-2xl tw-gap-2 tw-items-center tw-justify-around"
        style={{
          width: 300,
          height: 300,
          scale,
        }}
      >

        <div className="tw-text-slate-700 tw-font-medium tw-text-center">{data && data.title}</div>

        <div>
          {data && data.images && data.images.length > 0
            && (
            <img
              alt=""
              className="tw-rounded-md tw-object-contain tw-pointer-events-none tw-select-none"
              src={data.images[0].image_url}
            />
            )}
        </div>

        <div className="tw-select-none tw-items-baseline?">
          {data && data.kinds && data.kinds.length > 0 && (
          <Multiple tags={data.kinds} limit={3} textColor="tw-text-blue-800" bgColor="tw-bg-blue-100" linkify={false} />
          )}
        </div>

        <div className="tw-line-clamp-2 tw-text-slate-700 tw-text-xs tw-text-left tw-leading-5">{data && data.intro}</div>

      </motion.div>
    </motion.div>
  );
}
