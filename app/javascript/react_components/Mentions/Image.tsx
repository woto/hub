import * as React from "react";
import {useState, useRef, useEffect} from 'react';
import {
  motion,
  useDomEvent,
  AnimatePresence,
  useDragControls,
  LayoutGroup,
  useMotionValue,
  useSpring
} from "framer-motion";
import {useKey} from "react-use";
import {useGesture} from "@use-gesture/react";

const transition = {
  type: 'spring',
  damping: 50,
  stiffness: 500
}

export default function Image(props: { image: any, url: string }) {
  const [open, setOpen] = useState(false);
  const [blockClick, setBlockClick] = useState(false);

  const x = useMotionValue(0);
  const y = useMotionValue(0);

  const xSpring = useSpring(x, transition);
  const ySpring = useSpring(y, transition);

  let width = props?.image?.width ?? 0;
  let height = props?.image?.height ?? 0;

  const imageIndex = open ? 1000 : 300

  const xScale = (width / imageIndex) || 1
  const yScale = (height / imageIndex) || 1

  const ratio = (width / height) || 1

  let scaledWidth = width / xScale
  let scaledHeight = height / xScale

  width = scaledWidth;
  height = scaledHeight;

  const screenWidth = document.body.clientWidth;
  const screenHeight = document.body.clientHeight;

  const xConstraint = Math.abs(((width / 2) - screenWidth / 2));
  const yConstraint = Math.abs(((height / 2) - screenHeight / 2));

  const zoomOutImage = () => {
    setOpen((prevVal) => !prevVal);
    xSpring.set(0)
    ySpring.set(0)
  }

  useKey('Escape', () => {
    setOpen(false)
  });

  useEffect(() => {
    // https://stackoverflow.com/posts/4770179/revisions

    function preventDefault(e) {
      e.preventDefault();
    }

    if (open) {
      window.addEventListener('wheel', preventDefault, {passive: false})
      window.addEventListener('touchmove', preventDefault, {passive: false})
    }

    return () => {
      window.removeEventListener('wheel', preventDefault)
      window.removeEventListener('touchmove', preventDefault)
    }
  })

  return (
    <div
      className={`tw-flex tw-justify-center? tw-items-center? tw-w-full? tw-p-3`}>

      <motion.div
        animate={{opacity: open ? 1 : 0}}
        transition={transition}
        className={`tw-cursor-zoom-out 
            ${open ?
            'tw-pointer-events-auto tw-fixed tw-inset-0 tw-bg-black/30 tw-z-30' : 
            'tw-pointer-events-none'}`}
        onClick={zoomOutImage}
      />

      <motion.img
        className="tw-bg-white tw-m-auto tw-invisible"
        src={props?.image?.images['300']}
      />

      <>
        <motion.img
          data-test-id={open ? `big-image-${props.image?.id}` : `small-image-${props.image?.id}`}
          onLayoutAnimationComplete={() => {
            if(!open) {
              x.set(0)
              y.set(0)
            }
          }}
          className={`tw-m-auto
              ${open ?
              "tw-z-40 -tw-inset-[1000px] tw-cursor-zoom-out tw-fixed tw-max-w-none tw-rounded-lg tw-p-2 tw-border-2 tw-border-transparent tw-ring-8 tw-ring-black/20 tw-ring-inset" :
              "tw-z-[5] tw-inset-0 tw-cursor-zoom-in tw-absolute tw-w-full? tw-h-full? tw-max-w-full? tw-max-h-full? tw-shadow-sm tw-border tw-rounded-lg"}
            `}
          dragConstraints={{
            left: -xConstraint,
            right: xConstraint,
            top: -yConstraint,
            bottom: yConstraint
          }}
          // dragSnapToOrigin
          onDragStart={() => {
            setBlockClick(true)
          }}
          drag={open}
          dragTransition={{
            power: 0.1,
            min: 0.1,
            max: 1,
            timeConstant: 100
          }}
          layout
          transition={transition}
          style={{
            width: width,
            height: height,
            x: open ? x : xSpring,
            y: open ? y : ySpring,
          }}
          onPointerUp={() => {
            if (!blockClick) zoomOutImage();
            setBlockClick(false);
          }}
          // onMouseOut={() => {
          //   setBlockClick(false);
          // }}
          src={props.image?.images[imageIndex.toString()]}
        />

        <AnimatePresence>
          {open &&
            <motion.div
              transition={{delay: 0.2}}
              initial={{opacity: 0, y: 50}}
              animate={{opacity: 1, y: 0}}
              className={"tw-fixed tw-inset-x-0 tw-bottom-40 tw-z-50 tw-flex"}
            >
              <a href={props.url}
                 className="tw-block tw-mx-auto tw-flex tw-items-center tw-px-8 tw-py-3 tw-border
                      tw-border-transparent tw-shadow-md hover:tw-shadow tw-text-lg tw-font-medium tw-rounded-full
                      tw-text-pink-50 tw-bg-slate-700 hover:tw-bg-slate-600 focus:tw-outline-none
                      focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-slate-700"
              >
                Перейти к материалу
              </a>
            </motion.div>
          }
        </AnimatePresence>
      </>
    </div>
  )
}