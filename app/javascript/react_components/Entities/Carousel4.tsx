import * as React from 'react';
import {Dispatch, memo, SetStateAction, useEffect, useState} from "react";
import {animate, motion, useMotionValue, useScroll} from "framer-motion/dist/framer-motion";

function Carousel4(props: {
  items: any
}) {
  console.log('rendered');

  return (
    <>
      {props.items.map((item: any) => (
        <motion.div
          className={`
              tw-p-5 tw-flex-grow-0 tw-flex-shrink-0 tw-basis-[200px] tw-bg-indigo-200 tw-rounded-2xl tw-select-none`}
          key={item.id}>

          <div className={'tw-bg-slate-50 tw-text-lg'}>{JSON.stringify(item)}</div>
          <a href={`#`}
             className="tw-select-none tw-block tw-block tw-bg-slate-600" draggable={false}>test link</a>

        </motion.div>
      ))}
    </>
  )
}

export default React.memo(Carousel4);