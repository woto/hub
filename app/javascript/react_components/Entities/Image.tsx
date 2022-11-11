import * as React from "react";
import { useState, useRef } from 'react';
import {motion, useDomEvent, AnimatePresence} from "framer-motion";

const transition = {
  type: 'spring',
  damping: 50,
  stiffness: 500
}
export default function Image(props: {image: any}) {
  const [open, setOpen] = useState(false);

  return (
    <div className={`tw-bg-white tw-flex tw-justify-center tw-items-center tw-px-2 tw-py-0.5 tw-border tw-rounded tw-min-h-[70px]`}>
      <div className={`tw-relative tw-w-full`}>

        <motion.div
          animate={{ opacity: open ? 1 : 0 }}
          transition={transition}
          className={`tw-cursor-zoom-out ${open ? 'tw-pointer-events-auto tw-fixed tw-inset-0 tw-bg-black/50 tw-z-30' : 'tw-pointer-events-none'}`}
          onClick={() => setOpen(false)}
        />

        <img className="tw-bg-white" src={props.image.images['50']} />

        <motion.img
          className={`bg-white tw-inset-0 ${open ? "tw-z-40 tw-cursor-zoom-out tw-fixed tw-w-auto tw-h-auto tw-max-w-full tw-m-auto" : "tw-z-20 tw-cursor-zoom-in tw-absolute tw-w-full tw-h-full"}`}
          src={props.image.images['300']}
          onClick={() => setOpen(!open)}
          layout
          transition={transition}
        />

      </div>
    </div>
  )
}
