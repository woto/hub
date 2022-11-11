import * as React from 'react';
import {
  useState, useEffect, useId, useContext,
} from 'react';
import {
  motion,
  AnimatePresence, LayoutGroup,
} from 'framer-motion';
import { useKey, useWindowSize } from 'react-use';
import TailwindConfigContext from '../TailwindConfig/TailwindConfigContext';

function Image(props: { image: any, url: string, layoutGroupId: string }) {
  const { width, height } = useWindowSize();
  const tailwindConfig = useContext(TailwindConfigContext);
  // const imageSize = width > parseInt(tailwindConfig.theme.screens['2xl'].slice(0, -2)) ? '300' : '300';
  // const imageSize = '300';
  const imageSize = (window.screen.availWidth > 1600 && window.innerWidth > 768) ? '500' : '300';
  const [imageSrcWithFallback, setImageSrcWithFallback] = useState(props.image?.images[imageSize]);
  const [open, setOpen] = useState(false);
  const [blockClick, setBlockClick] = useState(false);

  const tmpMethodName = (imageIndex) => {
    const width = props?.image?.width ?? 0;
    const height = props?.image?.height ?? 0;

    const xScale = (width / imageIndex) || 1;
    const yScale = (height / imageIndex) || 1;

    const ratio = (width / height) || 1;

    const screenWidth = document.body.clientWidth;
    const screenHeight = document.body.clientHeight;

    const scaledWidth = width / xScale;
    const scaledHeight = height / xScale;

    return {
      imageSrc: props.image?.images[imageIndex.toString()],
      xConstraint: Math.abs(((scaledWidth / 2) - screenWidth / 2)),
      yConstraint: Math.abs(((scaledHeight / 2) - screenHeight / 2)),
      scaledWidth,
      scaledHeight,
    };
  };

  useKey('Escape', () => {
    setOpen(false);
  });

  useEffect(() => {
    // https://stackoverflow.com/posts/4770179/revisions

    function preventDefault(e) {
      e.preventDefault();
    }

    if (open) {
      window.addEventListener('wheel', preventDefault, { passive: false });
      window.addEventListener('touchmove', preventDefault, { passive: false });
    }

    return () => {
      window.removeEventListener('wheel', preventDefault);
      window.removeEventListener('touchmove', preventDefault);
    };
  });

  useEffect(() => {
    if (open) {
      setImageSrcWithFallback(tmpMethodName(1000).imageSrc);
    }
  }, [open]);

  // console.log(tmpMethodName(1000))

  return (
  // <LayoutGroup id={Math.random().toString()}>
    <div
      className="tw-flex tw-relative tw-flex-grow justify-self-center tw-items-center tw-w-full tw-py-1.5"
    >

      <motion.div
        animate={{ opacity: open ? 1 : 0 }}
        className={`
        tw-cursor-zoom-out
        ${open
          ? 'tw-pointer-events-auto tw-fixed tw-inset-0 tw-bg-slate-500/50 tw-z-40'
          : 'tw-pointer-events-none'}`}
        onClick={() => setOpen(false)}
      />

      <AnimatePresence>
        {open
            && (
            <motion.img
              key={`mention-image-${props.image?.id}-${props.layoutGroupId}`}
              layoutId={`mention-image-${props.image?.id}-${props.layoutGroupId}`}
              data-test-id={`big-image-${props.image?.id}`}
              className={`tw-bg-white tw-m-auto tw-z-40 -tw-inset-[1000px] tw-cursor-zoom-out tw-fixed tw-max-w-none
                tw-p-2? tw-border-2? tw-border-transparent? tw-ring-2 tw-ring-slate-500/30 tw-ring-inset? tw-rounded`}
              dragConstraints={{
                left: -tmpMethodName(1000).xConstraint,
                right: tmpMethodName(1000).xConstraint,
                top: -tmpMethodName(1000).yConstraint,
                bottom: tmpMethodName(1000).yConstraint,
              }}
              // dragSnapToOrigin
              onDragStart={() => {
                setBlockClick(true);
              }}
              drag={open}
              dragTransition={{
                power: 0.1,
                min: 0.1,
                max: 1,
                timeConstant: 100,
              }}
              layout
              style={{
                width: tmpMethodName(1000).scaledWidth,
                height: tmpMethodName(1000).scaledHeight,
              }}
              onMouseUp={() => {
                if (!blockClick) {
                  setOpen(false);
                }
                setBlockClick(false);
              }}
              src={imageSrcWithFallback}
            />
            )}
      </AnimatePresence>

      <motion.img
        layoutId={`mention-image-${props.image?.id}-${props.layoutGroupId}`}
        layout
        className={`
            ${open && 'tw-invisible'}
            tw-shadow? xl:tw-shadow-md? tw-outline
            tw-outline-1 xl:tw-outline-1
            tw-outline-slate-200 tw-rounded-lg
            tw-bg-white tw-m-auto tw-cursor-zoom-in`}
        data-test-id={`small-image-${props.image?.id}`}
        src={props?.image?.images[imageSize]}
        style={{
          width: tmpMethodName(imageSize).scaledWidth,
          height: tmpMethodName(imageSize).scaledHeight,
        }}
        onClick={() => setOpen(true)}
      />

      <AnimatePresence>
        {open
            && (
            <motion.div
              transition={{ delay: 0.2 }}
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              className="tw-select-none tw-fixed tw-inset-x-0 tw-bottom-40 tw-z-50 tw-flex"
            >
              <a
                href={props.url}
                className="tw-select-none tw-mx-auto tw-flex tw-items-center tw-px-8 tw-py-3 tw-border
                      tw-border-transparent tw-shadow-md hover:tw-shadow tw-text-lg tw-font-medium tw-rounded-full
                      tw-text-pink-50 tw-bg-slate-700 hover:tw-bg-slate-600 focus:tw-outline-none
                      tw-ring-2 tw-ring-offset-2 tw-ring-offset-white focus:tw-ring-offset-lime-300 focus:tw-ring-indigo-500 tw-ring-indigo-500"
              >
                Перейти к материалу
              </a>
            </motion.div>
            )}
      </AnimatePresence>
    </div>
  // </LayoutGroup>
  );
}

export default React.memo(Image);
