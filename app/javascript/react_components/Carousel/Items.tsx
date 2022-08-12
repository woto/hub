import * as React from 'react';
import {Dispatch, memo, SetStateAction, useEffect, useState} from "react";
import {animate, motion, useMotionValue, useScroll} from "framer-motion/dist/framer-motion";

function Items(props: {
  items: any[]
}) {

  const tmpFunction = (item: any) => {
    const image_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp', 'image/vnd.microsoft.icon', 'image/svg+xml']
    const video_types = ['video/mp4', 'video/webm', 'application/mp4', 'video/mp4', 'video/quicktime', 'video/avi', 'video/mpeg', 'video/x-mpeg', 'video/x-msvideo', 'video/m4v', 'video/x-m4v', 'video/vnd.objectvideo']

    if (image_types.includes(item.mime_type)) {
      return (
        <img className={`
            ${item.dark ? 'tw-bg-slate-800' : 'tw-bg-white'}
            tw-cursor-pointer tw-select-none tw-max-h-full tw-object-scale-down tw-rounded tw-w-full`}
             draggable={false} src={item.images['500']}/>
      )
    } else if (video_types.includes(item.mime_type)) {
      return (
        <video
          className={"tw-select-none tw-max-h-full tw-rounded tw-w-full"}
          draggable={false}
          loop={true}
          autoPlay={true}
          controls={false}
          muted={true}
          src={item.videos['500']}
        />
      )
    } else if (item.mime_type === 'text') {
      return (
        <div className="tw-select-none tw-text-gray-800 tw-max-h-full tw-max-w-[400px] tw-justify-self-start tw-self-start" draggable={false}>
          {item.text}
        </div>
      )
    } else {
      return JSON.stringify(item);
    }
  }

  console.log(props.items);
  console.log('rendered');

  return (
    <>
      {props.items.map((item: any, index: number) => (
        <motion.div
          draggable={false}
          className={`
            tw-select-none tw-min-w-[300px] tw-flex tw-flex-grow tw-shrink-0 tw-justify-center tw-items-center tw-p-2 sm:tw-p-3 tw-rounded-md tw-bg-white`}
          key={index}>
          {tmpFunction(item)}
        </motion.div>
      ))}
    </>
  )
}

export default React.memo(Items);