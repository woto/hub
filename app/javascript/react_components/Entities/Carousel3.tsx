import * as React from 'react';
import { useEffect, useRef, useState } from "react";
import { animate, motion, useMotionValue, useScroll } from "framer-motion/dist/framer-motion";
import {useDebounce} from "react-use";

export default function Carousel3() {
  const ref = useRef<HTMLUListElement>(null);
  const { scrollXProgress } = useScroll({ container: ref });
  const [startX, setStartX] = useState(0);
  const [scrollLeft, setScrollLeft] = useState(0);
  const [trackMouse, setTrackMouse] = useState(false);
  const [animationComplete, setAnimationComplete] = useState(true);
  const [items, setItems] = useState<number[]>([]);

  useEffect(() => {
    const arr = new Array(100).fill(undefined).map((val, idx) => idx);
    setItems(arr);
  }, []);

  const x = useMotionValue(0);

  const handleMouseMove = (e: React.PointerEvent<HTMLUListElement>) => {
    if (!ref.current) return;
    if (!trackMouse) return;

    setAnimationComplete(false);

    const xVal = e.pageX - ref.current.offsetLeft;
    const walk = (xVal - startX) * 1; //scroll-fast

    let xDelta;
    if (scrollLeft - walk < 0) {
      xDelta = 0;
    } else if (scrollLeft - walk > ref.current.scrollWidth - ref.current.clientWidth) {
      xDelta = ref.current.scrollWidth - ref.current.clientWidth;
    } else {
      xDelta = scrollLeft - walk;
    }

    const controls = animate(x, xDelta, {
      type: "tween",
      ease: "circOut",
      // duration: 0.4,
      onUpdate: (val) => {
        if (!ref.current) return;
        ref.current.scrollLeft = val;
      },
      onComplete: () => {
        setAnimationComplete(true);
      },
      onStop: () => {
        setAnimationComplete(true);
      }
    });
    return controls.stop;
  };

  const handleMouseDown = (e: React.PointerEvent<HTMLUListElement>) => {
    if (!ref.current) return;

    setTrackMouse(true);

    const startX = e.pageX - ref.current.offsetLeft;
    setStartX(startX);

    const scrollLeft = ref.current.scrollLeft;
    setScrollLeft(scrollLeft);
  };

  const handleMouseLeave = () => {
    setTrackMouse(false);
  };

  const handleMouseUp = () => {
    setTrackMouse(false);
  };

  const [monitorScroll, setMonitorScroll] = useState<number>();

  useDebounce(
    () => {
      if (animationComplete) {
        x.set(monitorScroll);
      }
    },
    100,
    [monitorScroll]
  );

  return (
    <>
      {false &&
        <svg width="100" height="100" viewBox="0 0 100 100"
             className={"tw-sticky tw-top-[20px] tw-left-[20px] tw-rotate-90"}
        >
          <circle cx="50" cy="50" r="30" pathLength="1"
                  className="tw-stroke-amber-100 tw-opacity-10 tw-fill-transparent tw-stroke-[15%] [stroke-dashoffset:0]"/>
          <motion.circle
            cx="50"
            cy="50"
            r="30"
            pathLength="1"
            className="tw-stroke-blue-600 tw-fill-transparent tw-stroke-[15%] [stroke-dashoffset:0]"
            style={{pathLength: scrollXProgress}}
          />
        </svg>
      }
      <motion.ul
        className={`
          tw-flex tw-list-none tw-h-[300px] tw-overflow-x-scroll tw-py-[20px] tw-flex-grow-0 tw-flex-shrink-0 tw-basis-[600px] tw-mx-auto tw-my-0 tw-space-x-[20px]`}
        ref={ref}
        onMouseMove={handleMouseMove}
        onMouseDown={handleMouseDown}
        onMouseUp={handleMouseUp}
        onMouseLeave={handleMouseLeave}
        onScroll={(e) => setMonitorScroll(e.target.scrollLeft)}
      >
        {items.map((idx) => (
          <motion.li
            className={`
              ${trackMouse ? 'tw-cursor-grabbing' : 'tw-cursor-grab'}
              tw-flex-grow-0 tw-flex-shrink-0 tw-basis-[200px] tw-bg-indigo-200 tw-rounded-2xl tw-select-none`}
            key={idx}></motion.li>
        ))}
      </motion.ul>
    </>
  );
}
