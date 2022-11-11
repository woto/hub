import {ArrowLeftIcon} from "@heroicons/react/24/solid";
import * as React from "react";
import {
  animate,
  motion,
  useMotionValue,
  useScroll,
  useSpring,
  AnimatePresence,
  LayoutGroup
} from "framer-motion";
import {Dispatch, SetStateAction} from "react";

export default function ScrollLeftButton(props: {
  showScrollButton: boolean,
  scrollButtonClick: Dispatch<SetStateAction<number>>,
  xRef: React.MutableRefObject<HTMLElement>
}) {
  return (
    <AnimatePresence>
      {/*{!([0].includes(scrollXProgress.current)) && ref.current?.scrollLeft !== 0 &&*/}
      {props.showScrollButton &&
        <motion.button
          initial={{opacity: 0}}
          animate={{opacity: 1}}
          exit={{opacity: 0}}
          type="button"
          draggable={false}
          className={`tw-absolute tw-left-3 -tw-translate-x-1/2 tw-top-1/2 -tw-translate-y-1/2 -tw-mt-3
              tw-inline-flex tw-items-center tw-border tw-border-gray-300/80 tw-shadow
              tw-text-base tw-font-medium tw-rounded-full tw-text-gray-700 hover:tw-text-gray-800
              tw-bg-white/80 hover:tw-bg-gray-50/90 focus:tw-outline-none focus:tw-ring
              tw-backdrop-blur-[1px] tw-p-2
            `}
          onClick={() => props.scrollButtonClick(-props.xRef.current?.clientWidth / 1.5 + props.xRef.current?.scrollLeft)}
        >
          <ArrowLeftIcon className="tw-h-5 tw-w-5" aria-hidden="true"/>
        </motion.button>
      }
    </AnimatePresence>
  )
}
