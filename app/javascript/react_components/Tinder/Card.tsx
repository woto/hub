import * as React from 'react';
import {useEffect, useLayoutEffect, useRef, useState} from "react";
import {
  motion,
  useMotionValue,
  useTransform,
  AnimatePresence,
  useDomEvent,
  useSpring
} from "framer-motion/dist/framer-motion";
import {useQuery} from "react-query";
import axios from "axios";

import EntitiesTag from '../Entities/Tag'

export default function Card(props) {
  const x = useMotionValue(0);
  const scale = useTransform(x, [-300, 0, 300], [0.5, 1, 0.5]);
  const rotate = useTransform(x, [-300, 0, 300], [-45, 0, 45], {
    clamp: false
  });

  // const [testNumber, setTestNumber] = useState<number>();

  const {isLoading, error, data, isFetching} = useQuery(`card:${props.useQueryKey}`, () =>
    axios
      .get("http://192.168.1.73:3000/api/entities/random")
      .then((res) => res.data)
  );

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
      style={{
        width: 300,
        height: 300,
        position: "absolute",
        top: 0,
        x: x,
        rotate: rotate,
        cursor: "grab"
      }}
      whileTap={{cursor: "grabbing"}}
      drag={props.drag}
      dragConstraints={{
        top: 0,
        right: 0,
        bottom: 0,
        left: 0
      }}
      onDragEnd={handleDragEnd}
      initial={props.initial}
      animate={props.animate}
      transition={props.transition}
      exit={{
        x: exitX,
        opacity: 0,
        scale: 0.5,
        transition: {duration: 0.2}
      }}
    >
      <motion.div
        className={"tw-bg-white tw-p-4 tw-border-4 tw-border-indigo-500 tw-flex tw-flex-col tw-rounded-2xl tw-gap-2 tw-items-center tw-justify-around"}
        style={{
          width: 300,
          height: 300,
          scale: scale
        }}
      >

        <div className="tw-text-slate-700 tw-font-medium tw-text-center">{data && data.title}</div>

        <div>
          {data && data.images && data.images.length > 0 &&
            <img
              className="tw-rounded-md tw-object-contain tw-pointer-events-none tw-select-none"
              src={data.images[0].image_url}/>
          }
        </div>

        <div className="tw-flex tw-flex-wrap tw-gap-1 tw-select-none">
          {data && data.kinds && data.kinds.length > 0 && data.kinds.slice(0, 3).map((kind) =>
            <EntitiesTag
              tag={kind}
              textColor='tw-text-blue-800'
              bgColor='tw-bg-blue-100'
              linkify={false}
            />
          )}
        </div>

        <div className="tw-line-clamp-2 tw-text-slate-700 tw-text-xs tw-text-left tw-leading-5">{data && data.intro}</div>

      </motion.div>
    </motion.div>
  );
}
