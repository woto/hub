import * as React from 'react';
import {Fragment} from 'react';
import {
  BookmarkIcon,
  CalendarIcon,
  CubeIcon,
  EyeIcon,
  FireIcon,
  FlagIcon,
  PencilSquareIcon, PlusIcon,
  QueueListIcon
} from "@heroicons/react/24/outline";
import {motion} from 'framer-motion';
import {useState} from "react";
import TimeAgo from "../TimeAgo";
import Timeline from "./Timeline";
import {ClockIcon} from "@heroicons/react/24/solid";
import {openEditEntity} from "../system/Utility";
import Complain from "../Complain";
import OldBookmark from "../OldBookmark";

export default function Circles(props: {imageSrc: string}) {
  throw new Error('zzzzz');

  return (
    <div className="tw-p-1 tw-flex tw-items-center tw-space-x-2.5 tw-relative tw-z-0 tw-overflow-hidden">
      {props.imageSrc &&
        <a href={'#'}
           onClick={(e) => e.preventDefault()}
           className={"tw-rounded-full focus:tw-ring-indigo-300 focus:tw-ring tw-outline-none"}
        >
          <img
            className="tw-bg-white tw-relative tw-inline-block tw-h-10 tw-w-10
            tw-rounded-full tw-border-2 tw-border-white tw-border-dashed tw-object-scale-down"
            src={props.imageSrc}
          />
        </a>
      }
    </div>
  )
}
